###############################################################################
# LXC2 - Apache Web 2 (Debian base)
# eth0: 172.16.20.4/24  → vmbr1v tag20  (VLAN20 frontend)
# eth1: 10.0.0.20/24   → vmbr2v tag30  (VLAN30 backend)
# eth2: 10.0.99.150/24 → vmbr99v tag99 (VLAN99 admin)
###############################################################################
resource "proxmox_lxc" "lxc2_web" {
  target_node  = var.proxmox_node
  vmid         = var.lxc2_vmid
  hostname     = var.lxc2_hostname
  ostemplate   = "local:vztmpl/${var.template_debian}"
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

  # VLAN20 - recibe tráfico del proxy
  network {
    name     = "eth0"
    bridge   = "vmbr1v"
    ip       = var.lxc2_ip_vlan20
    tag      = 20
    firewall = true
  }

  # VLAN30 - conecta a MariaDB
  network {
    name     = "eth1"
    bridge   = "vmbr2v"
    ip       = var.lxc2_ip_vlan30
    tag      = 30
    firewall = true
  }

  # VLAN99 - administración
  network {
    name     = "eth2"
    bridge   = "vmbr99v"
    ip       = "10.0.99.150/24"
    gw       = "10.0.99.1"
    tag      = 99
    firewall = true
  }

  features { nesting = true }
}
