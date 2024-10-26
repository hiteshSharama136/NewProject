# Provision the Azure Blob Storage for storing transaction data.

# Provision the Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account
  resource_group_name       = var.resource_group
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
}

# Create a Blob container in the Storage Account
resource "azurerm_storage_container" "blob_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}
