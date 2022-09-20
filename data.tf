data "azuread_client_config" "main" {}
data "azurerm_subscription" "main" {}

data "http" "my_public_ip" {
  url = "https://ifconfig.me/ip" # alt ifconfig.co, ipv4.icanhazip.com
}