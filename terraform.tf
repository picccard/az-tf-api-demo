terraform {
  backend "azurerm" {
    resource_group_name  = "rg-euw-az-tf-api-demo"
    storage_account_name = "aztfapidemoeula"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.28.1"
    }
  }
}


# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Configure the Azure AD Provider
provider "azuread" {}