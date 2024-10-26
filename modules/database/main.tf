# Set up the Azure SQL Database or PostgreSQL for the app’s backend.

# Set up the Azure PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "db" {
  name                = "${var.env}-db"
  location            = var.location
  resource_group_name = var.resource_group
  administrator_login = "adminuser"
  administrator_password = "securepassword"
  storage_mb          = 5120
  version             = "12"
  sku_name            = "Standard_B1ms"
  subnet_id           = var.db_subnet_id
}

resource "azurerm_private_endpoint" "db_private_endpoint" {
  name                = "${var.env}-db-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.db_subnet_id

  private_service_connection {
    name                           = "${var.env}-db-connection"
    private_connection_resource_id = azurerm_postgresql_flexible_server.db.id
    subresource_names              = ["postgresqlServer"]
  }
}
