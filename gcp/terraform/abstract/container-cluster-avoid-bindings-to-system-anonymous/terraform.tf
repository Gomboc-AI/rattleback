# Provider config
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.13.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "google" {
  project = var.gcp_project
  default_labels = {
    "test-repo" = "rattleback",
    "test-path" = "gcp/terraform/container-cluster-avoid-bindings-to-system-anonymous"
  }
}
