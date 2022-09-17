# Create Application
resource "azuread_application" "web_app_sp" {
  display_name = "web-app-sp"
}

# Create Service Principal linked to the Application
resource "azuread_service_principal" "web_app_sp" {
  application_id = azuread_application.web_app_sp.application_id
}

# Create Application password (client secret)
resource "azuread_application_password" "web_app_sp_pwd" {
  application_object_id = azuread_application.web_app_sp.object_id
  end_date_relative     = "4320h" # expire in 6 months
}


# https://github.com/claranet/terraform-azurerm-regions/blob/master/REGIONS.md
module "appservice1" {
  source = "./modules/appservice"

  region               = "northeurope" # westeurope
  region_short         = "eun" # euw
  service_principal_id = azuread_service_principal.web_app_sp.id
}

module "appservice2" {
  source = "./modules/appservice"

  region               = "eastus" # eastus2
  region_short         = "ue" # ue2
  service_principal_id = azuread_service_principal.web_app_sp.id
}

