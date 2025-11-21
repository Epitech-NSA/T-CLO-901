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