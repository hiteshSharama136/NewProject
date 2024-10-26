variable "env" {
  description = "Environment name, e.g., test, stage, prod"
  type        = string
}

variable "location" {
  description = "Azure location where the resources will be created."
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group."
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network (VNet)."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_configs" {
  description = "List of subnets to be created in the VNet."
  type = list(object({
    subnet_name    = string
    address_prefix = string
  }))
  default = [
    {
      subnet_name    = "subnet1"
      address_prefix = "10.0.1.0/24"
    },
    {
      subnet_name    = "subnet2"
      address_prefix = "10.0.2.0/24"
    }
  ]
}

variable "appgw_subnet_cidr" {}  # Application Gateway subnet CIDR
variable "aks_subnet_cidr" {}    # AKS subnet CIDR