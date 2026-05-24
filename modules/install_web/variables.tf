variable "proxmox_host"        {}
variable "proxmox_ssh_password" {
    sensitive = true
    type = string
    }
variable "vmid"               {}