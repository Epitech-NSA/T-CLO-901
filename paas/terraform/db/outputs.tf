output "fqdn" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "db_name" {
  value = azurerm_mysql_flexible_database.db.name
}

output "administrator_login" {
  value = azurerm_mysql_flexible_server.mysql.administrator_login
}

output "administrator_password" {
  value = azurerm_mysql_flexible_server.mysql.administrator_password
  sensitive = true
}

output "server_name" {
    value = azurerm_mysql_flexible_server.mysql.name
}
