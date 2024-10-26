variable "location" {
  description = "Location where the Azure resources will be created."
  type        = string
}

variable "resource_group" {
  description = "Resource group name where the database will be created."
  type        = string
}

variable "database_name" {
  description = "The name of the PostgreSQL Flexible Server."
  type        = string
}

variable "admin_username" {
  description = "Admin username for the PostgreSQL database."
  type        = string
}

variable "admin_password" {
  description = "Admin password for the PostgreSQL database."
  type        = string
  sensitive   = true
}

variable "storage_mb" {
  description = "The maximum storage in MB for the PostgreSQL server."
  type        = number
  default     = 5120  # Default 5 GB
}

variable "postgresql_version" {
  description = "The PostgreSQL version to use."
  type        = string
  default     = "12"
}

variable "sku_name" {
  description = "The SKU name for the PostgreSQL server."
  type        = string
  default     = "Standard_B1ms"
}

variable "subnet_id" {
  description = "The ID of the subnet where the PostgreSQL server will be deployed."
  type        = string
}
