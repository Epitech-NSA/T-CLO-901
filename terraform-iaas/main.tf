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
    storage_account_name = "terracloudstate28602"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
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

module "network" {
  source = "./network"

  rg_name      = azurerm_resource_group.rg-nan_1.name
  rg_location  = azurerm_resource_group.rg-nan_1.location
  subnet = {
    name           = "subnet_iaas"
    address_prefix = "10.0.1.0/24"
  }
}

module "vm" {
  source = "./vm"

  rg_name      = azurerm_resource_group.rg-nan_1.name
  rg_location  = azurerm_resource_group.rg-nan_1.location
  subnet_id    = module.network.subnet_main_id
}


