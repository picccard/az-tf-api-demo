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
resource "azurerm_app_service_plan" "plan_euw_1" {
  name                = "plan-euw-win1"
  location            = azurerm_resource_group.rg_euw_tftest.location
  resource_group_name = 
  kind                = "Windows"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# App Service Plan
resource "azurerm_service_plan" "plan_euw_1" {
  name                = "example"
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  location            = azurerm_resource_group.rg_euw_tftest.location
  os_type             = "Windows"
  sku_name            = "B1"
}

# App Service
resource "azurerm_app_service" "this" {
  name                = "app-service-euw-win1-eula"
  location            = azurerm_resource_group.rg_euw_tftest.location
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  app_service_plan_id = azurerm_service_plan.plan_euw_1.id

  site_config {
    # Run "az webapp list-runtimes" for current supported values, but always
    # output the value of process.version from a running app because you might
    # not get the version you expect
    windows_fx_version = "node|16-lts"
  }
}




# Application Insights
resource "azurerm_application_insights" "this" {
  name                = "appi-euw-win1-eula"
  location            = azurerm_resource_group.rg_euw_tftest.location
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  application_type    = "web"
}
