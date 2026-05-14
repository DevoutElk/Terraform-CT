###############################################################################
# PASO 1 - Descargar plantilla LXC en Proxmox
# Se ejecuta primero. Ambas máquinas dependen de este paso.
###############################################################################
resource "null_resource" "download_template" {
  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "sudo pveam update",
      "sudo pveam download local ${var.template_file} || echo 'ERROR: plantilla no encontrada en catalogo'",
      "ls /var/lib/vz/template/cache/${var.template_file} || (echo 'ERROR: fichero no descargado'; exit 1)",
      "while [ ! -f /var/lib/vz/template/cache/${var.template_file} ]; do echo 'Esperando plantilla...'; sleep 5; done",
      "echo 'Plantilla lista!'"
    ]
  }
}


###############################################################################
# PASO 2A - Crear contenedor Frontend (VMID 200)
# Tiene interfaz pública (eth0/vmbr0) y privada (eth1/vmbr1)
# Actúa como router/NAT para la red interna
###############################################################################
resource "proxmox_lxc" "TERRAFORMTEST01" {
  depends_on   = [null_resource.download_template]
  count        = 1
  onboot       = true
  start        = true
  vmid         = "200"
  hostname     = var.hostname1
  ostype       = "debian"
  cores        = 2
  cpulimit     = 0
  memory       = 1024
  swap         = 512
  ostemplate   = "local:vztmpl/${var.template_file}"
  password     = var.ct_pass1
  pool         = ""
  unprivileged = true
  target_node  = var.proxmox_node

  rootfs {
    storage = "local"
    size    = "5G"
  }

  nameserver   = var.dns_server
  searchdomain = var.dns_domain

  # Interfaz pública - acceso desde red local
  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "192.168.1.166/24"
    gw       = "192.168.1.1"
    firewall = false
  }

  # Interfaz privada - red interna entre contenedores
  network {
    name     = "eth1"
    bridge   = "vmbr1"
    ip       = "172.16.0.2/16"
    firewall = false
  }

  features {
    nesting = true
  }
}


###############################################################################
# PASO 2B - Crear contenedor Backend (VMID 300)
# Solo tiene interfaz privada (eth1/vmbr1)
# Sale a internet a través del Frontend (172.16.0.2)
###############################################################################
resource "proxmox_lxc" "TERRAFORMTEST02" {
  depends_on   = [null_resource.download_template]
  count        = 1
  onboot       = true
  start        = true
  vmid         = "300"
  hostname     = var.hostname2
  ostype       = "debian"
  cores        = 2
  cpulimit     = 0
  memory       = 1024
  swap         = 512
  ostemplate   = "local:vztmpl/${var.template_file}"
  password     = var.ct_pass2
  pool         = ""
  unprivileged = true
  target_node  = var.proxmox_node

  rootfs {
    storage = "local"
    size    = "5G"
  }

  nameserver   = var.dns_server
  searchdomain = var.dns_domain

  # Solo interfaz privada - sin acceso directo desde el exterior
  network {
    name     = "eth1"
    bridge   = "vmbr1"
    ip       = "172.16.0.3/16"
    gw       = "172.16.0.2"  # gateway es el Frontend
    firewall = false
  }

  features {
    nesting = true
  }
}


###############################################################################
# PASO 3A - Instalar SSH en Frontend via pct exec
# Se conecta a Proxmox y ejecuta comandos dentro del contenedor 200
###############################################################################
resource "null_resource" "install_ssh_frontend" {
  depends_on = [proxmox_lxc.TERRAFORMTEST01]

  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",  # espera a que el contenedor arranque completamente
      "sudo pct exec 200 -- apt update",
      "sudo pct exec 200 -- apt install openssh-server -y",
      "sudo pct exec 200 -- systemctl enable ssh",
      "sudo pct exec 200 -- systemctl start ssh",
      "sudo pct exec 200 -- sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sudo pct exec 200 -- sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config",
      "sudo pct exec 200 -- systemctl restart ssh"
    ]
  }
}


###############################################################################
# PASO 3B - Instalar SSH en Backend via pct exec
# Se conecta a Proxmox y ejecuta comandos dentro del contenedor 300
# Se ejecuta en paralelo con el paso 3A
###############################################################################
resource "null_resource" "install_ssh_backend" {
  depends_on = [proxmox_lxc.TERRAFORMTEST02,
  null_resource.install_apache]

  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",  # espera a que el contenedor arranque completamente
      "sudo pct exec 300 -- apt update",
      "sudo pct exec 300 -- DEBIAN_FRONTEND=noninteractive apt install openssh-server -y",
      "sudo pct exec 300 -- systemctl enable ssh",
      "sudo pct exec 300 -- systemctl start ssh",
      "sudo pct exec 300 -- sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sudo pct exec 300 -- sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config",
      "sudo pct exec 300 -- systemctl restart ssh"
    ]
  }
}


###############################################################################
# PASO 4A - Configurar Frontend: Apache2 + NAT/iptables
# Se conecta directamente por SSH al contenedor via IP pública
###############################################################################
resource "null_resource" "install_apache" {
  depends_on = [null_resource.install_ssh_frontend]

  connection {
    type     = "ssh"
    user     = "root"
    password = var.ct_pass1
    host     = "192.168.1.166"
  }

  provisioner "file" {
    source      = "scripts/install_apache.sh"
    destination = "/tmp/install_apache.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_apache.sh",
      "bash /tmp/install_apache.sh"
    ]
  }
}


###############################################################################
# PASO 4B - Configurar Backend: instalar servicio
# Depende de que el Frontend esté configurado (NAT activo) para tener internet
# Se conecta via SSH usando la IP privada a través de la red interna
###############################################################################
resource "null_resource" "install_db" {
  depends_on = [
    null_resource.install_ssh_backend,
    null_resource.install_apache  # necesita el NAT del frontend para tener internet
  ]

  connection {
    type     = "ssh"
    user     = "root"
    password = var.ct_pass2
    host     = "172.16.0.3"
  }

  provisioner "file" {
    source      = "scripts/install_db.sh"
    destination = "/tmp/install_db.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_db.sh",
      "bash /tmp/install_db.sh"
    ]
  }
}
