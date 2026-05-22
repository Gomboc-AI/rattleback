variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "acme-prod-infra"
}

variable "zone" {
  description = "The GCP zone for resource deployment"
  type        = string
  default     = "us-central1-a"
}

variable "instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
  default     = "batch-worker-1"
}

variable "disk_name" {
  description = "Name of the attached persistent disk"
  type        = string
  default     = "batch-data-ssd"
}
