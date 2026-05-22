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

variable "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  type        = string
  default     = "acme-prod-data-lake-7f3a"
}
