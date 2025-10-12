variable "vm_admin_username" {
  type = string
  default = "ansible"
}

variable "ssh_public_key_path" {
  type = string
  default = "vm/id_rsa.pub"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1ls"
}
