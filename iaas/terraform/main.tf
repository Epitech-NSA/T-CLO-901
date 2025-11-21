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
  subnet = var.subnet
}

module "vm" {
  source = "./vm"

  rg_name      = data.azurerm_resource_group.rg-nan_1.name
  rg_location  = data.azurerm_resource_group.rg-nan_1.location
  subnet_id    = module.network.subnet_main_id
}

module "db" {
  source = "./db"

  rg_name      = data.azurerm_resource_group.rg-nan_1.name
  rg_location  = data.azurerm_resource_group.rg-nan_1.location
  database_login = var.database_login
  database_password = var.database_password
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventories/hosts.ini"

  content = <<EOT
[terra_cloud_app]
${module.vm.vm_app_public_ip}
EOT
}
