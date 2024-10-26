# Provision the AKS cluster with identity and networking configuration.

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.env}-aks"
  location            = var.location
  resource_group_name = var.resource_group
  dns_prefix          = "${var.env}-aks"

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = var.aks_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    dns_service_ip      = "10.0.0.10"
    service_cidr        = "10.0.0.0/24"
    docker_bridge_cidr  = "172.17.0.1/16"
  }
}

