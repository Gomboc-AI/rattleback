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

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "main-cluster"
}

variable "network" {
  description = "VPC network for the GKE cluster"
  type        = string
  default     = "default"
}
