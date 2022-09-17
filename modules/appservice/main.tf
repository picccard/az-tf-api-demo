# Reource Group
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.region_short}-express-api"
  location = var.region
}

# App Service Plan
resource "azurerm_service_plan" "this" {
  name                = "plan-${var.region_short}-eula"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Webapp
resource "azurerm_linux_web_app" "webapp1" {
  name                = "app-service-${var.region_short}-linux1-eula"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "14-lts"
    }
  }

  app_settings = {
    PICCCARD_RANDOM = "custom-env-var-${var.region_short}-linux1"
  }
}

# Create role assignment for Webapp
resource "azurerm_role_assignment" "contributor" {
  scope                = azurerm_linux_web_app.webapp1.id
  role_definition_name = "Contributor"
  principal_id         = var.service_principal_id
}