terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.50"
    }
  }

  required_version = ">= 1.1.0"

  backend "azurerm" {
    resource_group_name  = "rg-nan_1"
    storage_account_name = "sttcdevfrc01"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_resource_group" "rg-nan_1" {
  name     = var.rg_name
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.rg_name
}

module "network" {
  source = "./network"

  rg_name      = data.azurerm_resource_group.rg-nan_1.name
  rg_location  = data.azurerm_resource_group.rg-nan_1.location
  vnet         = var.vnet
  app_subnet   = var.app_subnet
  mysql_subnet = var.mysql_subnet
}

module "db" {
  source = "./db"

  rg_name           = data.azurerm_resource_group.rg-nan_1.name
  rg_location       = data.azurerm_resource_group.rg-nan_1.location
  database_login    = var.database_login
  database_password = var.database_password
}

module "app" {
  source = "./app"

  rg_name                   = data.azurerm_resource_group.rg-nan_1.name
  rg_location               = data.azurerm_resource_group.rg-nan_1.location
  acr_login_server          = data.azurerm_container_registry.acr.login_server
  acr_admin_username        = data.azurerm_container_registry.acr.admin_username
  acr_admin_password        = data.azurerm_container_registry.acr.admin_password
  db_fqdn                   = module.db.fqdn
  db_name                   = module.db.db_name
  db_administrator_login    = module.db.administrator_login
  db_administrator_password = module.db.administrator_password
  db_server_name            = module.db.server_name
}
