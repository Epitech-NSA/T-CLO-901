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

output "vm_traefik_public_ip" {
  description = "Adresse IP publique de la VM Traefik"
  value       = azurerm_public_ip.vm_traefik_ip.ip_address
}

output "vm_traefik_private_ip" {
  description = "Adresse IP privée de la VM Traefik"
  value       = azurerm_network_interface.vm_traefik_nic.private_ip_address
}

output "vm_traefik_name" {
  description = "Nom de la VM Traefik"
  value       = azurerm_linux_virtual_machine.vm_traefik.name
}

output "vm_db_public_ip" {
  description = "Adresse IP publique de la VM DB"
  value       = azurerm_public_ip.vm_db_ip.ip_address
}

output "vm_db_private_ip" {
  description = "Adresse IP privée de la VM DB"
  value       = azurerm_network_interface.vm_db_nic.private_ip_address
}

output "vm_db_name" {
  description = "Nom de la VM DB"
  value       = azurerm_linux_virtual_machine.vm_db.name
}

