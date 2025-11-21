resource "azurerm_service_plan" "app_plan" {
  name                = "tc-plan-paas-frc-01"
  location            = var.rg_location
  resource_group_name = var.rg_name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "tc-app-paas-frc-01"
  location            = var.rg_location
  resource_group_name = var.rg_name
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    always_on = true
    application_stack {
      docker_image_name   = "paas:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }
    app_command_line = "sh -c 'php artisan migrate --force && exec apache2-foreground'"
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${var.acr_login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.acr_admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.acr_admin_password

    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "DB_CONNECTION"     = "mysql"
    "DB_PORT"     = 3306
    "DB_HOST"     = var.db_fqdn
    "DB_DATABASE"     = var.db_name
    "DB_USERNAME"     = "${var.db_administrator_login}@${var.db_server_name}"
    "DB_PASSWORD" = var.db_administrator_password
  }
}
