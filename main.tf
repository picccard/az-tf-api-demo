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

# Reource Group EU 
resource "azurerm_resource_group" "rg_euw_tftest" {
  name     = "rg-euw-express-api"
  location = "westeurope"
}

# App Service Plan EU
resource "azurerm_service_plan" "plan_euw_1" {
  name                = "plan-euw-1"
  resource_group_name = azurerm_resource_group.rg_euw_tftest.name
  location            = azurerm_resource_group.rg_euw_tftest.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Webapp EU 1
resource "azurerm_linux_web_app" "webapp_euw_n1" {
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
    PICCCARD_RANDOM = "custom-env-var-euw-linux1"
  }
}

# Reource Group US
resource "azurerm_resource_group" "rg_ue2_tftest" {
  name     = "rg-ue2-express-api"
  location = "eastus2"
}

# App Service Plan US
resource "azurerm_service_plan" "plan_ue2_1" {
  name                = "plan-ue2-1"
  resource_group_name = azurerm_resource_group.rg_ue2_tftest.name
  location            = azurerm_resource_group.rg_ue2_tftest.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# Webapp US 1
resource "azurerm_linux_web_app" "webapp_ue2_n1" {
  name                = "app-service-ue2-linux1-eula"
  location            = azurerm_resource_group.rg_ue2_tftest.location
  resource_group_name = azurerm_resource_group.rg_ue2_tftest.name
  service_plan_id     = azurerm_service_plan.plan_ue2_1.id
  https_only          = true

  site_config {
    minimum_tls_version = "1.2"
    application_stack {
      node_version = "14-lts"
    }
  }

  app_settings = {
    PICCCARD_RANDOM = "custom-env-var-us2-linux1"
  }
}