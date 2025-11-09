variable "rg_name" {
  type        = string
}

variable "rg_location" {
  type        = string
}

variable "subnet" {
  type = object({
    name           = string
    address_prefix = string
  })
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  address_space = [var.vnet.address_space]
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "subnet_main" {
  name                 = var.subnet.name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet.address_prefix]
}