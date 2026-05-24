###############################################################################
# LXC3 - MariaDB (plantilla preconfigurada)
# eth0: 10.0.0.30/24   → vmbr2v tag30  (VLAN30 backend)
# eth1: 10.0.99.100/24 → vmbr99v tag99 (VLAN99 admin)
# Puerto 3306 solo desde LXC1 y LXC2
###############################################################################
resource "proxmox_lxc" "lxc3_db" {
  target_node  = var.proxmox_node
  vmid         = var.lxc3_vmid
  hostname     = var.lxc3_hostname
  ostemplate   = "local:vztmpl/${var.template_db_file}"
  password     = var.lxc_password
  ostype       = "debian"
  cores        = 1
  memory       = 512
  swap         = 512
  onboot       = true
  start        = true
  unprivileged = true

  rootfs {
    storage = "local"
    size    = "20G"
  }

  nameserver   = "1.1.1.1"
  searchdomain = "1.1.1.1"

  # VLAN30 - solo acepta conexiones de LXC1/LXC2
  network {
    name     = "eth0"
    bridge   = "vmbr2v"
    ip       = var.lxc3_ip_vlan30
    tag      = 30
    firewall = true
  }

  # VLAN99 - administración
  network {
    name     = "eth1"
    bridge   = "vmbr99v"
    ip       = "10.0.99.100/24"
    gw       = "10.0.99.1"
    tag      = 99
    firewall = true
  }

  features { nesting = true }
}
