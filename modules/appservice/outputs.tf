output "webappname" {
  value = azurerm_linux_web_app.webapp1.name
}

output "webapp_default_hostname" {
  value = azurerm_linux_web_app.webapp1.default_hostname
}

output "url" {
  value = "https://${azurerm_linux_web_app.webapp1.name}.azurewebsites.net"
}