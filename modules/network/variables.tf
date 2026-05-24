variable "proxmox_host"        { description = "IP Proxmox" }
variable "proxmox_ssh_password" { 
    description = "Password SSH terraform"
    sensitive = true
    type = string
    }
