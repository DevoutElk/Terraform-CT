variable "proxmox_node"     {}
variable "lxc3_vmid"        {}
variable "lxc3_hostname"    {}
variable "lxc_password" {
  sensitive = true
  type      = string
}
variable "template_db_file" {}
variable "lxc3_ip_vlan30"   {}
variable "template_db_ready"{ default = "" }
variable "network_ready"    { default = "" }
