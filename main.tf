###############################################################################
# MAIN.TF - Punto de entrada
# Orden de ejecución:
#   1. network  → verifica OVS bridges (vmbr1v, vmbr2v, vmbr99v)
#   2. template → descarga las 3 plantillas en paralelo
#   3. lxc0/1/2/3 → crea los contenedores
###############################################################################

module "network" {
  source               = "./modules/network"
  proxmox_host         = var.proxmox_host
  proxmox_ssh_password = var.proxmox_ssh_password
}

module "template" {
  source               = "./modules/template"
  proxmox_host         = var.proxmox_host
  proxmox_ssh_password = var.proxmox_ssh_password
  template_debian      = var.template_debian
  template_nginx_url   = var.template_nginx_url
  template_nginx_file  = var.template_nginx_file
  template_db_url      = var.template_db_url
  template_db_file     = var.template_db_file
}

module "lxc0_proxy" {
  source      = "./containers/lxc0_proxy"
  depends_on  = [module.network, module.template]

  proxmox_node        = var.proxmox_node
  lxc0_vmid           = var.lxc0_vmid
  lxc0_hostname       = var.lxc0_hostname
  lxc_password        = var.lxc_password
  template_nginx_file = var.template_nginx_file
  lxc0_ip_pub         = var.lxc0_ip_pub
  lxc0_ip_vlan20      = var.lxc0_ip_vlan20
}

module "lxc1_web" {
  source      = "./containers/lxc1_web"
  depends_on  = [module.network, module.template]

  proxmox_node    = var.proxmox_node
  lxc1_vmid       = var.lxc1_vmid
  lxc1_hostname   = var.lxc1_hostname
  lxc_password    = var.lxc_password
  template_debian = var.template_debian
  lxc1_ip_vlan20  = var.lxc1_ip_vlan20
  lxc1_ip_vlan30  = var.lxc1_ip_vlan30
}

module "lxc2_web" {
  source      = "./containers/lxc2_web"
  depends_on  = [module.network, module.template]

  proxmox_node    = var.proxmox_node
  lxc2_vmid       = var.lxc2_vmid
  lxc2_hostname   = var.lxc2_hostname
  lxc_password    = var.lxc_password
  template_debian = var.template_debian
  lxc2_ip_vlan20  = var.lxc2_ip_vlan20
  lxc2_ip_vlan30  = var.lxc2_ip_vlan30
}

module "lxc3_db" {
  source      = "./containers/lxc3_db"
  depends_on  = [module.network, module.template]

  proxmox_node     = var.proxmox_node
  lxc3_vmid        = var.lxc3_vmid
  lxc3_hostname    = var.lxc3_hostname
  lxc_password     = var.lxc_password
  template_db_file = var.template_db_file
  lxc3_ip_vlan30   = var.lxc3_ip_vlan30
}

module "install_web_lxc1" {
  source               = "./modules/install_web"
  depends_on           = [module.lxc1_web]
  proxmox_host         = var.proxmox_host
  proxmox_ssh_password = var.proxmox_ssh_password
  vmid                 = var.lxc1_vmid
}

module "install_web_lxc2" {
  source               = "./modules/install_web"
  depends_on           = [module.lxc2_web]
  proxmox_host         = var.proxmox_host
  proxmox_ssh_password = var.proxmox_ssh_password
  vmid                 = var.lxc2_vmid
}