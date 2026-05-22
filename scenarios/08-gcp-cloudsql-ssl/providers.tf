terraform {
  required_version = ">= 1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
  }
}

provider "google" {
  project = "acme-prod-infra"
  region  = "us-central1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
