terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "rg-nan_1" {
  name     = var.rg_name
  location = var.rg_location
  tags     = var.rg_tags
}

resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage.name
  account_replication_type        = var.storage.account_replication_type
  account_tier                    = var.storage.account_tier
  location                        = var.rg_location
  resource_group_name             = var.rg_name
  min_tls_version                 = var.storage.min_tls
  allow_nested_items_to_be_public = var.storage_allow_nested_items_to_be_public
  tags = {}
  timeouts {}
}

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

resource "azurerm_service_plan" "app_plan" {
  name                = "app-plan"
  location            = var.rg_location
  resource_group_name = var.rg_name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_mysql_flexible_server" "mysql" {
  name                         = "nan-mysql-serv"
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
  name                = "db"
  resource_group_name = var.rg_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "nan-webapp"
  location            = var.rg_location
  resource_group_name = var.rg_name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "phpapp:latest"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password

    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "DB_CONNECTION"     = "mysql"
    "DB_PORT"     = 3306
    "DB_HOST"     = azurerm_mysql_flexible_server.mysql.fqdn
    "DB_DATABASE"     = azurerm_mysql_flexible_database.db.name
    "DB_USERNAME"     = "${azurerm_mysql_flexible_server.mysql.administrator_login}@${azurerm_mysql_flexible_server.mysql.name}"
    "DB_PASSWORD" = azurerm_mysql_flexible_server.mysql.administrator_password
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "nanacr${random_integer.suffix.result}"
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}