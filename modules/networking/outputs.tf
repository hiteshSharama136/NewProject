output "public_subnet_id" {
  value = azurerm_subnet.public_subnet.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "db_nsg_id" {
  value = azurerm_network_security_group.db_nsg.id
}
