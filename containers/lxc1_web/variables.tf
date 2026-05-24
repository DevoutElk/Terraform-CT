variable "proxmox_node"         {}
variable "lxc1_vmid"            {}
variable "lxc1_hostname"        {}
variable "lxc_password" {
  sensitive = true
  type      = string
}
variable "template_debian"      {}
variable "lxc1_ip_vlan20"       {}
variable "lxc1_ip_vlan30"       {}
variable "template_debian_ready"{ default = "" }
variable "network_ready"        { default = "" }
