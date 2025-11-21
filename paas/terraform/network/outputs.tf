output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "mysql_subnet_id" {
  value = azurerm_subnet.mysql_subnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
