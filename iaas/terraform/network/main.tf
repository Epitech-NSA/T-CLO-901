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

resource "azurerm_network_security_group" "nsg" {
  name                = "tc-nsg-iaas-frc-01"
  location            = var.rg_location
  resource_group_name = var.rg_name

  security_rule {

    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {

    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}



resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet_main.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
