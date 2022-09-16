output "display_name" {
  value = azuread_service_principal.web_app_sp.display_name
}

output "client_id" {
  value = azuread_application.web_app_sp.application_id
}

output "client_secret" {
  value     = azuread_application_password.web_app_sp_pwd.value
  sensitive = true
}

output "tenant_id" {
  value = data.azuread_client_config.main.tenant_id
}