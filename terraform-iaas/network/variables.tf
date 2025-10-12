variable "vnet" {
  type = map(string)
  default = {
    name = "vnet_iaas"
    address_space = "10.0.0.0/16"
  }
}