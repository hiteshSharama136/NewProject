output "postgresql_flexible_server_name" {
  description = "The name of the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.db.name
}

output "postgresql_flexible_server_fqdn" {
  description = "The FQDN of the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.db.fqdn
}

output "postgresql_flexible_server_administrator_login" {
  description = "The administrator login name for the PostgreSQL Flexible Server."
  value       = azurerm_postgresql_flexible_server.db.administrator_login
}

output "postgresql_flexible_server_connection_string" {
  description = "The connection string for connecting to the PostgreSQL server."
  value       = format("postgresql://%s:%s@%s:5432/%s?sslmode=require",
    azurerm_postgresql_flexible_server.db.administrator_login,
    var.admin_password,
    azurerm_postgresql_flexible_server.db.fqdn,
    var.database_name
  )
}
