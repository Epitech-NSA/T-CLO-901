variable "vnet" {
  type = map(string)
  default = {
    name = "tc-vnet-iaas-frc-001"
    address_space = "10.0.0.0/16"
  }
}