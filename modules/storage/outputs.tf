# Output the name of the Storage Account
output "storage_account_name" {
  description = "The name of the Azure Storage Account"
  value       = azurerm_storage_account.storage.name
}

# Output the Blob Container name
output "blob_container_name" {
  description = "The name of the Blob Container"
  value       = azurerm_storage_container.blob_container.name
}

# Output the primary connection string for the Storage Account
output "primary_connection_string" {
  description = "The primary connection string of the Storage Account"
  value       = azurerm_storage_account.storage.primary_connection_string
}

# Output the Blob Container URL
output "blob_container_url" {
  description = "The URL of the Blob Container"
  value       = azurerm_storage_container.blob_container.url
}
