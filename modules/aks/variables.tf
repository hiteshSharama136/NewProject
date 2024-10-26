variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure location where the resources will be created"
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group in which the AKS cluster will be created"
  type        = string
}

variable "env" {
  description = "Environment name (e.g., test, stage, production)"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "The VM size to use for the AKS node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
