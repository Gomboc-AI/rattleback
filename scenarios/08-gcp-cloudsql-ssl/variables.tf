variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "acme-prod-infra"
}

variable "region" {
  description = "The GCP region for resource deployment"
  type        = string
  default     = "us-central1"
}

variable "instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
  default     = "orders-mysql-prod"
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "orders"
}

variable "authorized_networks" {
  description = "Map of authorized networks for the Cloud SQL instance"
  type        = map(string)
  default = {
    "allow-all" = "0.0.0.0/0"
  }
}

variable "namespace" {
  description = "Kubernetes namespace for the orders workloads"
  type        = string
  default     = "orders"
}

variable "orders_api_image" {
  description = "Container image for the orders-api deployment"
  type        = string
  default     = "acme/orders-api:v2.4.1"
}
