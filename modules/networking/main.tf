# Create the VNet, subnets, and NSG (Network Security Groups).

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
    name                       = "AllowAppGateway"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.appgw_subnet_cidr
    destination_address_prefix = "*"
    destination_port_range     = "5432" # PostgreSQL default port
  }

  security_rule {
    name                       = "AllowAKS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = var.aks_subnet_cidr
    destination_address_prefix = "*"
    destination_port_range     = "5432"
  }
}