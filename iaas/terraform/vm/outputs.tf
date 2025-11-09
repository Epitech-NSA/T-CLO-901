output "vm_app_public_ip" {
  description = "Adresse IP publique de la VM App"
  value       = azurerm_public_ip.vm_app_ip.ip_address
}

output "vm_app_private_ip" {
  description = "Adresse IP privée de la VM App"
  value       = azurerm_network_interface.vm_app_nic.private_ip_address
}

output "vm_app_name" {
  description = "Nom de la VM App"
  value       = azurerm_linux_virtual_machine.vm_app.name
}

