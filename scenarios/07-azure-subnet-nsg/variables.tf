variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-prod-network"
}

variable "location" {
  description = "Azure region for resource deployment"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-prod"
}

variable "subnet_name" {
  description = "Name of the application-tier subnet"
  type        = string
  default     = "snet-app-tier"
}
