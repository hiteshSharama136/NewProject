variable "storage_account" {
  description = "The name of the Azure Storage Account."
  type        = string
}

variable "resource_group" {
  description = "The resource group where the storage account will be created."
  type        = string
}

variable "location" {
  description = "The location for the Azure resources."
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account (Standard or Premium)."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account (LRS, GRS, RA-GRS)."
  type        = string
  default     = "LRS"
}

variable "container_name" {
  description = "The name of the Blob container."
  type        = string
  default     = "transactions"
}
