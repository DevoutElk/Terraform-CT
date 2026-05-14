###############################################################################
# CONEXIÓN A PROXMOX
###############################################################################
variable "pve_host" {
  description = "URL de la API de Proxmox"
}

variable "proxmox_host" {
  description = "IP del servidor Proxmox (para conexiones SSH)"
}

variable "proxmox_node" {
  description = "Nombre del nodo Proxmox"
}

###############################################################################
# AUTENTICACIÓN PROXMOX
###############################################################################
variable "pve_token_id" {
  description = "Token ID para conexión a la API (ej: terraform@pam!terraform)"
  type        = string
  sensitive   = true
}

variable "pve_secret" {
  description = "Token Secret para conexión a la API de Proxmox"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_password" {
  description = "Contraseña SSH del usuario terraform en Proxmox"
  type        = string
  sensitive   = true
}

###############################################################################
# PLANTILLA LXC
###############################################################################
variable "template_file" {
  description = "Nombre del fichero de plantilla LXC a descargar y usar"
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

###############################################################################
# CONTENEDOR FRONTEND (VMID 200)
###############################################################################
variable "hostname1" {
  description = "Hostname del contenedor Frontend"
}

variable "ct_pass1" {
  description = "Contraseña root del contenedor Frontend"
  type        = string
  sensitive   = true
}

###############################################################################
# CONTENEDOR BACKEND (VMID 300)
###############################################################################
variable "hostname2" {
  description = "Hostname del contenedor Backend"
}

variable "ct_pass2" {
  description = "Contraseña root del contenedor Backend"
  type        = string
  sensitive   = true
}

###############################################################################
# IP & VMID's
###############################################################################

variable "ip_frontend"     { description = "IP pública del contenedor Frontend" }
variable "ip_backend"      { description = "IP privada del contenedor Backend" }
variable "ip_gateway_pub"  { description = "Gateway red pública" }
variable "ip_gateway_priv" { description = "Gateway red privada (Frontend)" }
variable "vmid_frontend"   { description = "VMID del contenedor Frontend" }
variable "vmid_backend"    { description = "VMID del contenedor Backend" }