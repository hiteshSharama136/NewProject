variable "env" {
  description = "The environment for the resources (test, stage, production)"
  type        = string
}

variable "location" {
  description = "The location where the Application Gateway will be deployed."
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the Application Gateway will be deployed."
  type        = string
}

variable "aks_private_ip" {}

variable "ssl_certificate_path" {}

variable "ssl_certificate_password" {}

variable "public_ip_id" {}

variable "public_subnet_id" {}