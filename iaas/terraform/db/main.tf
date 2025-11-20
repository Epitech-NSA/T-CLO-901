variable "rg_name" {
  type        = string
}

variable "rg_location" {
  type        = string
}

variable "database_login" {
  type        = string
}

variable "database_password" {
  type        = string
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                         = "tc-mysql-iaas-frc-001"
  resource_group_name          = var.rg_name
  location                     = var.rg_location
  administrator_login          = var.database_login
  administrator_password       = var.database_password
  version                      = "8.0.21"
  sku_name                     = "B_Standard_B1ms"
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
}

resource "azurerm_mysql_flexible_database" "db" {
  name                = "tc-db-iaas-app-frc-001"
  resource_group_name = var.rg_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}