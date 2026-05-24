###############################################################################
# CONEXIÓN A PROXMOX
###############################################################################
variable "pve_host" {
  description = "URL de la API de Proxmox"
}

variable "proxmox_host" {
  description = "IP del servidor Proxmox (conexiones SSH)"
}

variable "proxmox_node" {
  description = "Nombre del nodo Proxmox"
}

###############################################################################
# AUTENTICACIÓN
###############################################################################
variable "pve_token_id" {
  description = "Token ID para la API (ej: terraform@pam!terraform)"
  type        = string
  sensitive   = true
}

variable "pve_secret" {
  description = "Token Secret para la API de Proxmox"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_password" {
  description = "Contraseña SSH del usuario terraform en Proxmox"
  type        = string
  sensitive   = true
}

###############################################################################
# PLANTILLAS
###############################################################################
variable "template_debian" {
  description = "Nombre plantilla Debian base (via pveam)"
}

variable "template_nginx_url" {
  description = "URL descarga plantilla LXC0 Nginx preconfigurada"
}

variable "template_nginx_file" {
  description = "Nombre del fichero plantilla Nginx"
}

variable "template_db_url" {
  description = "URL descarga plantilla LXC3 MariaDB preconfigurada"
}

variable "template_db_file" {
  description = "Nombre del fichero plantilla MariaDB"
}

###############################################################################
# RED
###############################################################################
variable "dns_server" {
  description = "IP del servidor DNS"
}

variable "dns_domain" {
  description = "Dominio de búsqueda DNS"
}

variable "gw_vlan20" {
  description = "Gateway VLAN20 en Proxmox"
  default     = "172.16.20.1/24"
}

variable "gw_vlan30" {
  description = "Gateway VLAN30 en Proxmox"
  default     = "10.0.0.1/24"
}

###############################################################################
# CONTRASEÑA COMPARTIDA CONTENEDORES
###############################################################################
variable "lxc_password" {
  description = "Contraseña root compartida para todos los contenedores"
  type        = string
  sensitive   = true
}

###############################################################################
# LXC0 - PROXY (Nginx)
# eth0: 192.168.1.167/24 (vmbr0)
# eth1: 172.16.20.2/24  (ovsbr20)
###############################################################################
variable "lxc0_vmid"     { description = "VMID LXC0 Proxy" }
variable "lxc0_hostname" { description = "Hostname LXC0" }
variable "lxc0_ip_pub"   { description = "IP pública LXC0 (vmbr0)" }
variable "lxc0_ip_vlan20"{ description = "IP LXC0 en VLAN20" }

###############################################################################
# LXC1 - Apache Web 1
# eth0: 172.16.20.3/24 (ovsbr20)
# eth1: 10.0.0.10/24  (ovsbr30)
###############################################################################
variable "lxc1_vmid"      { description = "VMID LXC1 Web1" }
variable "lxc1_hostname"  { description = "Hostname LXC1" }
variable "lxc1_ip_vlan20" { description = "IP LXC1 en VLAN20" }
variable "lxc1_ip_vlan30" { description = "IP LXC1 en VLAN30" }

###############################################################################
# LXC2 - Apache Web 2
# eth0: 172.16.20.4/24 (ovsbr20)
# eth1: 10.0.0.20/24  (ovsbr30)
###############################################################################
variable "lxc2_vmid"      { description = "VMID LXC2 Web2" }
variable "lxc2_hostname"  { description = "Hostname LXC2" }
variable "lxc2_ip_vlan20" { description = "IP LXC2 en VLAN20" }
variable "lxc2_ip_vlan30" { description = "IP LXC2 en VLAN30" }

###############################################################################
# LXC3 - MariaDB
# eth0: 10.0.0.30/24 (ovsbr30)
###############################################################################
variable "lxc3_vmid"      { description = "VMID LXC3 MariaDB" }
variable "lxc3_hostname"  { description = "Hostname LXC3" }
variable "lxc3_ip_vlan30" { description = "IP LXC3 en VLAN30" }
