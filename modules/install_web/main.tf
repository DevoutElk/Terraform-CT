resource "null_resource" "install_web" {
  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo pct exec ${var.vmid} -- bash -c 'apt install -y curl && curl -fsSL https://raw.githubusercontent.com/DevoutElk/web-con-bdd/main/install_web.sh | bash'"
    ]
  }
}