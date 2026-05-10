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

resource "proxmox_lxc" "TERRAFORMTEST01" {
  depends_on   = [null_resource.download_template]
  count        = 1
  onboot       = true
  start        = true
  vmid         = "200"
  hostname     = var.hostname
  ostype       = "debian"
  cores        = 2
  cpulimit     = 0
  memory       = 1024
  swap         = 512
  ostemplate   = "local:vztmpl/${var.template_file}"
  password     = var.ct_pass
  pool         = ""
  unprivileged = true
  target_node  = var.proxmox_node

  rootfs {
    storage = "local"
    size    = "5G"
  }

  nameserver   = var.dns_server
  searchdomain = var.dns_domain

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "192.168.1.166/24"
    gw       = "192.168.1.1"
    firewall = false
  }

  features {
    nesting = true
  }
}

resource "null_resource" "install_ssh" {
  depends_on = [proxmox_lxc.TERRAFORMTEST01]

  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo pct exec 200 -- apt update",
      "sudo pct exec 200 -- apt install -y openssh-server",
      "sudo pct exec 200 -- systemctl enable ssh",
      "sudo pct exec 200 -- systemctl start ssh",
      "sudo pct exec 200 -- sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sudo pct exec 200 -- sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config",
      "sudo pct exec 200 -- systemctl restart ssh"
    ]
  }
}

resource "null_resource" "install_apache" {
  depends_on = [null_resource.install_ssh]

  connection {
    type     = "ssh"
    user     = "root"
    password = var.ct_pass
    host     = "192.168.1.166"
  }

  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt install -y apache2",
      "systemctl enable apache2",
      "systemctl start apache2"
    ]
  }
}
#