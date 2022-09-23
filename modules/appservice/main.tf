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

    ip_restriction = [
      {
        ip_address                = null
        virtual_network_subnet_id = null
        service_tag               = "AzureFrontDoor.Backend"
        headers                   = [
          {
            "x_forwarded_host" = var.frontdoor_fqdn # allow the frontdoor to forwards traffic to this webapp
            "x_azure_fdid" = []
            "x_fd_health_probe" = []
            "x_forwarded_for" = []
          }
        ]
        name                      = "Access_via_frontdoor"
        description               = "Access_via_frontdoor"
        priority                  = 169
        action                    = "Allow"
      },
      {
        ip_address                = var.my_public_ip # 12.34.56.78/32
        virtual_network_subnet_id = null
        service_tag               = null
        headers                   = []
        name                      = "Access_via_homeip"
        description               = "Access_via_homeip"
        priority                  = 269
        action                    = "Allow"
      }
    ]
  }

  app_settings = {
    PICCCARD_RANDOM = "region-${var.region}-linux1"
  }
}

# Create role assignment for Webapp
resource "azurerm_role_assignment" "contributor" {
  scope                = azurerm_linux_web_app.webapp1.id
  role_definition_name = "Contributor"
  principal_id         = var.service_principal_id
}