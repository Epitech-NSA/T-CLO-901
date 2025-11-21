resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  address_space = [var.vnet.address_space]
  location            = var.rg_location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "app_subnet" {
  name                 = var.app_subnet.name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.app_subnet.address_prefixes]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "mysql_subnet" {
  name                 = var.mysql_subnet.name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = [var.mysql_subnet.address_prefixes]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
