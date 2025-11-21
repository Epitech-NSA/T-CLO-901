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

resource "azurerm_storage_account" "storage_account" {
  name                            = var.storage.name
  account_replication_type        = var.storage.account_replication_type
  account_tier                    = var.storage.account_tier
  location                        = var.rg_location
  resource_group_name             = var.rg_name
  min_tls_version                 = var.storage.min_tls
  allow_nested_items_to_be_public = var.storage_allow_nested_items_to_be_public
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  sku                 = "Basic"
  admin_enabled       = true
}