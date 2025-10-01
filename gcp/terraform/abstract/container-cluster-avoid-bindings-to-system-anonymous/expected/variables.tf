variable "gcp_project" {
  type        = string
  description = "The GCP project to create the cluster in"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
  default     = "uut-cluster"
}

variable "location" {
  type        = string
  description = "The location/region for the cluster"
  default     = "us-central1"
}

variable "machine_type" {
  type        = string
  description = "The machine type for the cluster nodes"
  default     = "e2-medium"
}
