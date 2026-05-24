###############################################################################
# MÓDULO: network
# Los bridges OVS ya están configurados en /etc/network/interfaces:
#   vmbr1v → VLAN20 Frontend (172.16.20.0/24)
#   vmbr2v → VLAN30 Backend  (10.0.0.0/24)
#   vmbr99v→ VLAN99 Admin    (10.0.99.0/24)
#
# Este módulo solo verifica que están activos antes de crear los LXC
###############################################################################
resource "null_resource" "check_bridges" {
  connection {
    type     = "ssh"
    user     = "terraform"
    password = var.proxmox_ssh_password
    host     = var.proxmox_host
  }

  provisioner "remote-exec" {
    inline = [
      "ip link show vmbr1v  || (echo 'ERROR: vmbr1v no existe'; exit 1)",
      "ip link show vmbr2v  || (echo 'ERROR: vmbr2v no existe'; exit 1)",
      "ip link show vmbr99v || (echo 'ERROR: vmbr99v no existe'; exit 1)",
      "echo 'Bridges verificados: vmbr1v, vmbr2v, vmbr99v OK'"
    ]
  }
}
