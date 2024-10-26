output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "aks_node_resource_group" {
  description = "The resource group containing the AKS cluster nodes"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "kube_config" {
  description = "Kubeconfig for connecting to the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
