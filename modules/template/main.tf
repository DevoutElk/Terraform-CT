###############################################################################
# MÓDULO: template
# Descarga las 3 plantillas LXC en Proxmox:
#   1. Debian base     → via pveam
#   2. Nginx           → via curl desde Dropbox
#   3. MariaDB         → via curl desde Dropbox
###############################################################################

# Plantilla 1 - Debian base via pveam
resource "null_resource" "template_debian" {
  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "sudo pveam update",
      "sudo pveam download local ${var.template_debian} || echo 'Plantilla ya existente'",
      "ls /var/lib/vz/template/cache/${var.template_debian} || (echo 'ERROR: plantilla debian no descargada'; exit 1)",
      "echo 'Plantilla Debian lista!'"
    ]
  }
}

# Plantilla 2 - Nginx preconfigurada via curl
resource "null_resource" "template_nginx" {
  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "ls /var/lib/vz/template/cache/${var.template_nginx_file} || curl -L -m 300 --progress-bar '${var.template_nginx_url}' -o /var/lib/vz/template/cache/${var.template_nginx_file}",
      "ls /var/lib/vz/template/cache/${var.template_nginx_file} || (echo 'ERROR: plantilla nginx no descargada'; exit 1)",
      "echo 'Plantilla Nginx lista!'"
    ]
  }
}

# Plantilla 3 - MariaDB preconfigurada via curl
resource "null_resource" "template_db" {
  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "ls /var/lib/vz/template/cache/${var.template_db_file} || curl -L -m 300 --progress-bar '${var.template_db_url}' -o /var/lib/vz/template/cache/${var.template_db_file}",
      "ls /var/lib/vz/template/cache/${var.template_db_file} || (echo 'ERROR: plantilla db no descargada'; exit 1)",
      "echo 'Plantilla MariaDB lista!'"
    ]
  }
}



