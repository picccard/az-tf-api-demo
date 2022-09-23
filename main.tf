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

locals {
  frontdoor_name = "example-eula-frontdoor"
}

# https://github.com/claranet/terraform-azurerm-regions/blob/master/REGIONS.md
module "appservice1" {
  source = "./modules/appservice"

  region               = "northeurope" # westeurope
  region_short         = "eun"         # euw
  service_principal_id = azuread_service_principal.web_app_sp.id

  my_public_ip         = "${data.http.my_public_ip.response_body}/32"
  frontdoor_fqdn       = ["${local.frontdoor_name}.azurefd.net", "${local.frontdoor_name}2.azurefd.net"]

}

module "appservice2" {
  source = "./modules/appservice"

  region               = "eastus" # eastus2
  region_short         = "ue"     # ue2
  service_principal_id = azuread_service_principal.web_app_sp.id

  my_public_ip         = "${data.http.my_public_ip.response_body}/32"
  frontdoor_fqdn       = ["${local.frontdoor_name}.azurefd.net", "${local.frontdoor_name}2.azurefd.net"]
}

# Reource Group
resource "azurerm_resource_group" "frontdoor" {
  name     = "rg-eun-frontdoor"
  location = "northeurope"
}

# Front Door
resource "azurerm_frontdoor" "fd_express_api" {
  name                = local.frontdoor_name
  resource_group_name = azurerm_resource_group.frontdoor.name

  frontend_endpoint {
    name      = "exampleEulaFrontendEndpoint1"
    host_name = "${local.frontdoor_name}.azurefd.net"
  }


  backend_pool_load_balancing {
    name = "exampleLoadBalancingSettings1"
    # additional_latency_milliseconds = 0 # 700 # every backend that responds 
  }

  backend_pool_health_probe {
    name     = "exampleHealthProbeSetting1"
    protocol = "Https"
  }

  backend_pool_settings {
    enforce_backend_pools_certificate_name_check = false # stop terraform plan 
  }

  backend_pool {
    name                = "exampleBackendBing"
    load_balancing_name = "exampleLoadBalancingSettings1"
    health_probe_name   = "exampleHealthProbeSetting1"

    backend {
      address     = module.appservice1.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      host_header = module.appservice1.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      http_port   = 80
      https_port  = 443
    }

    backend {
      address     = module.appservice2.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      host_header = module.appservice2.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      http_port   = 80
      https_port  = 443
    }
  }

  backend_pool {
    name                = "eu-backend-pool"
    load_balancing_name = "exampleLoadBalancingSettings1"
    health_probe_name   = "exampleHealthProbeSetting1"

    backend {
      address     = module.appservice1.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      host_header = module.appservice1.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      http_port   = 80
      https_port  = 443
    }
  }

  backend_pool {
    name                = "us-backend-pool"
    load_balancing_name = "exampleLoadBalancingSettings1"
    health_probe_name   = "exampleHealthProbeSetting1"

    backend {
      address     = module.appservice2.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      host_header = module.appservice2.webapp_default_hostname # azurerm_linux_web_app.my_app.default_hostname
      http_port   = 80
      https_port  = 443
    }
  }

  routing_rule {
    name               = "exampleRoutingRule1"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["exampleEulaFrontendEndpoint1"]
    forwarding_configuration {
      forwarding_protocol = "HttpsOnly" # HttpOnly, HttpsOnly (default), MatchRequest
      backend_pool_name   = "exampleBackendBing"
    }
  }
}