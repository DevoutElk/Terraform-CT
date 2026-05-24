variable "proxmox_host"        { description = "IP Proxmox" }
variable "proxmox_ssh_password" {
    description = "Password SSH terraform"
    sensitive = true
    type = string 
    }
variable "template_debian"      { description = "Nombre plantilla Debian" }
variable "template_nginx_url"   { description = "URL plantilla Nginx" }
variable "template_nginx_file"  { description = "Fichero plantilla Nginx" }
variable "template_db_url"      { description = "URL plantilla MariaDB" }
variable "template_db_file"     { description = "Fichero plantilla MariaDB" }
