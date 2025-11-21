output "vm_app_public_ip" {
  value = module.vm.vm_app_public_ip
}

output "vm_app_private_ip" {
  value = module.vm.vm_app_private_ip
}

output "vm_app_name" {
  value = module.vm.vm_app_name
}

output "acr_name" {
  value = data.azurerm_container_registry.acr.name
}

output "acr_password" {
  value = data.azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "db_host" {
  value = module.db.db_host
  sensitive = true
}

output "db_database" {
  value = module.db.db_database
}

output "db_username" {
  value = module.db.db_username
}

output "db_password" {
  value     = module.db.db_password
  sensitive = true
}