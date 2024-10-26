# Output the Application Gateway's public IP
output "appgw_public_ip" {
  description = "The public IP address of the Application Gateway"
  value       = azurerm_public_ip.appgw_public_ip.ip_address
}

# Output the Application Gateway's frontend configuration
output "appgw_frontend_ip" {
  description = "The frontend IP configuration of the Application Gateway"
  value       = azurerm_application_gateway.appgw.frontend_ip_configuration
}

# Output the Application Gateway's backend pool
output "appgw_backend_pool" {
  description = "The backend pool of the Application Gateway"
  value       = azurerm_application_gateway.appgw.backend_address_pool
}
