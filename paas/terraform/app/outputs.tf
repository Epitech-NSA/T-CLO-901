output "webapp_name" {
  value = azurerm_linux_web_app.web_app.name
}

output "webapp_hostname" {
  value = azurerm_linux_web_app.web_app.default_hostname
}
