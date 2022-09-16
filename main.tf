terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}


# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# remote tfstate
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-euw-az-tf-api-demo"
    storage_account_name = "aztfapidemoeula"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

# Reource Group
resource "azurerm_resource_group" "rg_euw_tftest" {
  name     = "rg-euw-tftest"
  location = "westeurope"
}

# App Service Plan
resource "azurerm_service_plan" "plan_euw_1" {
  name                = "plan-euw-1"
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  location            = azurerm_resource_group.rg_euw_tftest.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Webapp 1
resource "azurerm_linux_web_app" "webapp" {
  name                = "app-service-euw-linux1-eula"
  location            = azurerm_resource_group.rg_euw_tftest.location
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  service_plan_id     = azurerm_service_plan.plan_euw_1.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "14-lts"
    }
  }

  app_settings = {
    PICCCARD_RANDOM = "custom-env-var-linux1"
  }
}