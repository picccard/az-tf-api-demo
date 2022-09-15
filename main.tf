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
  name                = "example"
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  location            = azurerm_resource_group.rg_euw_tftest.location
  os_type             = "Windows"
  sku_name            = "B1"
}

# App Service 1
resource "azurerm_windows_web_app" "win1" {
  name                = "app-service-euw-win1-eula"
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  location            = azurerm_resource_group.rg_euw_tftest.location
  service_plan_id     = azurerm_service_plan.plan_euw_1.id

  site_config {}
}

# App Slot 1
resource "azurerm_windows_web_app_slot" "win1_blue" {
  name           = "blue"
  app_service_id = azurerm_windows_web_app.win1.id

  site_config {
    application_stack {
      current_stack = "node"
      node_version  = "16-LTS"
    }
  }
}

# App Slot 2
resource "azurerm_windows_web_app_slot" "win1_green" {
  name           = "green"
  app_service_id = azurerm_windows_web_app.win1.id

  site_config {
    application_stack {
      current_stack = "node"
      node_version  = "16-LTS"
    }
  }
}
