variable "proxmox_node"         {}
variable "lxc2_vmid"            {}
variable "lxc2_hostname"        {}
variable "lxc_password" {
  sensitive = true
  type      = string
}
variable "template_debian"      {}
variable "lxc2_ip_vlan20"       {}
variable "lxc2_ip_vlan30"       {}
variable "template_debian_ready"{ default = "" }
variable "network_ready"        { default = "" }
