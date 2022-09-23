output "github_secret" {
  value     = <<GITHUBSECRET
  {
    "clientId": "${azuread_application.web_app_sp.application_id}",
    "clientSecret": "${azuread_application_password.web_app_sp_pwd.value}",
    "subscriptionId": "${data.azurerm_subscription.main.subscription_id}",
    "tenantId": "${data.azuread_client_config.main.tenant_id}"
  }
  GITHUBSECRET
  sensitive = true
}

/*
output "client_id" {
  value = azuread_application.web_app_sp.application_id
}

output "client_secret" {
  value     = azuread_application_password.web_app_sp_pwd.value
  sensitive = true
}

output "subscriptionId" {
  value = data.azurerm_subscription.main.subscription_id
}

output "tenant_id" {
  value = data.azuread_client_config.main.tenant_id
}

output "webapppname1" {
  value = module.appservice1.webappname
}

output "webapppname2" {
  value = module.appservice2.webappname
}

output "webapppname1_url" {
  value = module.appservice1.url
}

output "webapppname2_url" {
  value = module.appservice2.url
}
*/