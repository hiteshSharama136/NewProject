# Define the Azure provider and Terraform backend for remote state management.

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstate{unique-suffix}"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}


1. ############################# 

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.env}-vnet"
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = ["10.0.0.0/16"]
}

# Public Subnet for Application Gateway
resource "azurerm_subnet" "public_subnet" {
  name                 = "${var.env}-public-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "appgw_delegation"
    service_delegation {
      name = "Microsoft.Network/applicationGateways"
    }
  }
}

# Private Subnet for AKS Cluster
resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.env}-aks-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Private Subnet for PostgreSQL Database
resource "azurerm_subnet" "db_subnet" {
  name                 = "${var.env}-db-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "${var.env}-db-nsg"
  location            = var.location
  resource_group_name = var.resource_group

  security_rule {
    name                       = "AllowAKSToDB"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = azurerm_subnet.aks_subnet.address_prefixes[0]
    destination_address_prefix = azurerm_subnet.db_subnet.address_prefixes[0]
  }
}


2. # ############### Application Gateway Backend Address Pool Pointing to AKS

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
    subnet_id = azurerm_subnet.public_subnet.id
  }

  frontend_port {
    name = "http"
    port = 80
  }

  backend_address_pool {
    name = "aks-backend-pool"
    backend_addresses {
      ip_address = azurerm_kubernetes_cluster.aks.default_node_pool[0].private_ip_address
    }
  }

  http_listener {
    name                           = "aks-http-listener"
    frontend_ip_configuration_name = "appgw-ip-config"
    frontend_port_name             = "http"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "http-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "aks-http-listener"
    backend_address_pool_name  = "aks-backend-pool"
  }
}


3. ###############################  HTTPS and SSL Certificate for Application Gateway

resource "azurerm_application_gateway" "appgw" {
  # Existing configuration...

  ssl_certificate {
    name     = "${var.env}-ssl-cert"
    data     = filebase64("${path.module}/certs/appgw-cert.pfx")
    password = var.ssl_password
  }

  frontend_port {
    name = "https"
    port = 443
  }

  http_listener {
    name                           = "aks-https-listener"
    frontend_ip_configuration_name = "appgw-ip-config"
    frontend_port_name             = "https"
    protocol                       = "Https"
    ssl_certificate_name           = "${var.env}-ssl-cert"
  }

  request_routing_rule {
    name                       = "https-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "aks-https-listener"
    backend_address_pool_name  = "aks-backend-pool"
  }
}



4. #################### Application Gateway Integration with AKS

resource "azurerm_kubernetes_cluster" "aks" {
  # AKS Configuration...
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    dns_service_ip    = "10.0.0.10"
    service_cidr      = "10.0.0.0/16"
  }

  addon_profile {
    ingress_application_gateway {
      enabled = true
      gateway_id = azurerm_application_gateway.appgw.id
    }
  }
}

5. #######################3 PostgreSQL Secure Subnet with Firewall Rules

resource "azurerm_postgresql_flexible_server" "db" {
  # PostgreSQL Configuration...
  delegated_subnet_id = azurerm_subnet.db_subnet.id
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_aks" {
  name                = "AllowAKS"
  resource_group_name = var.resource_group
  server_name         = azurerm_postgresql_flexible_server.db.name
  start_ip_address    = azurerm_subnet.aks_subnet.address_prefixes[0]
  end_ip_address      = azurerm_subnet.aks_subnet.address_prefixes[0]
}


6. #####################3 Azure Private Link and Private Endpoints Integration

resource "azurerm_private_endpoint" "appgw_private_link" {
  name                = "${var.env}-appgw-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.aks_subnet.id

  private_service_connection {
    name                           = "appgw-private-link"
    private_connection_resource_id = azurerm_application_gateway.appgw.id
    subresource_names              = ["gateway"]
  }
}

resource "azurerm_private_endpoint" "postgres_private_link" {
  name                = "${var.env}-postgres-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = azurerm_subnet.db_subnet.id

  private_service_connection {
    name                           = "postgres-private-link"
    private_connection_resource_id = azurerm_postgresql_flexible_server.db.id
    subresource_names              = ["postgresqlServer"]
  }
}

