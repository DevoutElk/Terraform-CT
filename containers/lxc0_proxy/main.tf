###############################################################################
# LXC0 - PROXY (Nginx preconfigurado)
# eth0: 192.168.1.167/24 → vmbr0       (red pública)
# eth1: 172.16.20.2/24  → vmbr1v tag20 (VLAN20 frontend)
###############################################################################
resource "proxmox_lxc" "lxc0_proxy" {
  target_node  = var.proxmox_node
  vmid         = var.lxc0_vmid
  hostname     = var.lxc0_hostname
  ostemplate   = "local:vztmpl/${var.template_nginx_file}"
  password     = var.lxc_password
  ostype       = "debian"
  cores        = 1
  memory       = 1024
  swap         = 512
  onboot       = true
  start        = true
  unprivileged = true

  rootfs {
    storage = "local"
    size    = "8G"
  }

  nameserver   = "1.1.1.1"
  searchdomain = "1.1.1.1"

  # Red pública
  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "192.168.1.167/24"
    gw       = "192.168.1.1"
    firewall = true
  }

  # VLAN20 - frontend
  network {
    name     = "eth1"
    bridge   = "vmbr1v"
    ip       = var.lxc0_ip_vlan20
    tag      = 20
    firewall = true
  }

  features { nesting = true }
}
