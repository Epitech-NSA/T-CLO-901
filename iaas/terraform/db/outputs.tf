output "db_host" {
  value = azurerm_mysql_flexible_server.mysql.fqdn
}

output "db_database" {
  value = azurerm_mysql_flexible_database.db.name
}

output "db_username" {
  value = azurerm_mysql_flexible_server.mysql.administrator_login
}

output "db_password" {
  value     = azurerm_mysql_flexible_server.mysql.administrator_password
}