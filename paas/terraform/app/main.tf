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
  https_only          = true

  site_config {
    application_stack {
      docker_image_name   = "image-paas:latest"
      docker_registry_url = "https://${var.acr_login_server}"
      docker_registry_username = var.acr_admin_username
      docker_registry_password = var.acr_admin_password
    }
    minimum_tls_version = "1.2"
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    WEBSITES_PORT               = "80"
    DOCKER_ENABLE_CI            = "true"

    APP_DEBUG                   = "false"
    APP_ENV                     = "production"
    APP_KEY                     = "base64:DJYTvaRkEZ/YcQsX3TMpB0iCjgme2rhlIOus9A1hnj4="

    DB_CONNECTION               = "mysql"
    DB_HOST                     = var.db_fqdn
    DB_PORT                     = "3306"
    DB_DATABASE                 = var.db_name
    DB_USERNAME                 = var.db_administrator_login
    DB_PASSWORD                 = var.db_administrator_password
  }
}
