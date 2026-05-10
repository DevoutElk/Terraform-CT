# DATOS SERVIDOR PROXMOX
variable "pve_host" {
  description = "Servidor Proxmox"
  default     = "https://192.168.1.165:8006/api2/json"
}

variable "proxmox_host" {
  default = "192.168.1.165"
}


# TOKEN DE CONEXIÓN
variable "pve_token_id" {
  description = "Token ID para conexión a Proxmox (ej: terraform@pve!terraform)"
  type        = string
  sensitive   = true
  default     = "terraform@pam!terraform"
}

variable "pve_secret" {
  description = "Token Secret para conexión a Proxmox"
  type        = string
  sensitive   = true
  default     = "27e6e8bd-9c97-4a12-9c70-d2084ddc55f2"
}

# Nombre nodo proxmox

variable "proxmox_node" {
default = "pve"
}


# Contraseña terraform

variable "proxmox_ssh_password" {
  default   = "tamaolipas"
  sensitive = true
}

#### Template CT

variable "template_file" {
  default = "debian-12-standard_12.12-1_amd64.tar.zst"
}


################################# Configuracion  CT LXC ###########################
# CONTRASEÑA DEL USUARIO LINUX ROOT DEL CONTENEDOR LXC (opcional si usamos SSH keys)
variable "ct_pass" {
  description = "Contraseña root del contenedor LXC (opcional si usamos ssh_keys)"
  type        = string
  sensitive   = true
  default     = "default"
}

# NOMBRE DEL CONTENEDOR LXC
variable "hostname" {
  default = "CTApache"
}

# SERVIDOR DNS
variable "dns_server" {
  default = "192.168.1.1"
}


# DOMINIO
variable "dns_domain" {
  default = "pve.home"
}

# DATOS SSH-KEY PARA ACCESO AL CONTENEDOR LXC
#variable "ssh_key" {
#  default = "ssh-rsa #AAAAB3NzaC1yc2EAAAADAQABAAAAgQDZhM/sCkAPITumaeIqMlUxlO/f1ZTpHcVgYqy+xYeZdU#hJg7qfWvOguzC00jmvJ73NiDzm9nIVIBh+492IrltP3G3xN8gyLSuhholKDROP/IjCp9msXeU0#.1cXI9zKlgJBKDUzin0B1INCHPQzx5wHS1Zpn69nqaMk7ak57Nu5NyQ=="
#}





