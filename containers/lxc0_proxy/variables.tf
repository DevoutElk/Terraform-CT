variable "proxmox_node"        {}
variable "lxc0_vmid"           {}
variable "lxc0_hostname"       {}
variable "lxc_password" {
  sensitive = true
  type      = string
}
variable "template_nginx_file" {}
variable "lxc0_ip_pub"         {}
variable "lxc0_ip_vlan20"      {}
variable "template_nginx_ready"{ default = "" }
variable "network_ready"       { default = "" }
