# Set up the Application Gateway for handling inbound traffic.

# Set up the Application Gateway for handling inbound traffic.
resource "azurerm_application_gateway" "appgw" {
  name                = "${var.env}-appgw"
  location            = var.location
  resource_group_name = var.resource_group
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.public_subnet_id
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = var.public_ip_id
  }

  frontend_port {
    name = "https"
    port = 443
  }

  ssl_certificate {
    name     = "appgw-ssl-cert"
    data     = filebase64(var.ssl_certificate_path)
    password = var.ssl_certificate_password
  }

  http_listener {
    name                           = "appgw-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "https"
    ssl_certificate_name           = "appgw-ssl-cert"
    protocol                       = "Https"
  }

  backend_http_settings {
    name                  = "https-settings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 20
  }

  backend_address_pool {
    name         = "aks-backend-pool"
    ip_addresses = [var.aks_private_ip]
  }

  request_routing_rule {
    name                       = "https-rule"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-listener"
    backend_address_pool_name  = "aks-backend-pool"
    backend_http_settings_name = "https-settings"
  }
}
