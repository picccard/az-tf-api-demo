output "webappname" {
  value = azurerm_linux_web_app.webapp1.name
}

output "url" {
  value = "https://${azurerm_linux_web_app.webapp1.name}.azurewebsites.net"
}