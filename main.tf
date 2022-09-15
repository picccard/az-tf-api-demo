provider "azurerm" {
  version = "=3.0.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-euw-az-tf-api-demo"
    storage_account_name = "aztfapidemoeula"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "rg-euw-tftest" {
  name     = "rg-euw-tftest"
  location = "westeurope"
}
