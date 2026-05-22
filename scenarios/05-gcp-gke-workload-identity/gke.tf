data "google_client_config" "default" {}

# SA: projects/acme-prod-infra/serviceAccounts/gke-node-sa@acme-prod-infra.iam.gserviceaccount.com
resource "google_service_account" "gke_nodes" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
  project      = var.project_id
}

resource "google_project_iam_member" "gke_nodes_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_nodes_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# GKE cluster: projects/acme-prod-infra/locations/us-central1/clusters/main-cluster
resource "google_container_cluster" "main" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id
  network  = var.network

  initial_node_count       = 1
  remove_default_node_pool = true

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
}

# Node pool: projects/acme-prod-infra/locations/us-central1/clusters/main-cluster/nodePools/general-pool
resource "google_container_node_pool" "general" {
  name     = "general-pool"
  cluster  = google_container_cluster.main.name
  location = var.region
  project  = var.project_id

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    machine_type    = "e2-standard-4"
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      pool = "general"
    }

    tags = ["gke-node", "general"]
  }
}

# Node pool: projects/acme-prod-infra/locations/us-central1/clusters/main-cluster/nodePools/highmem-pool
resource "google_container_node_pool" "highmem" {
  name     = "highmem-pool"
  cluster  = google_container_cluster.main.name
  location = var.region
  project  = var.project_id

  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }

  node_config {
    machine_type    = "n2-highmem-4"
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      pool = "highmem"
    }

    tags = ["gke-node", "highmem"]
  }
}

# GKE cluster: projects/acme-prod-infra/locations/us-central1/clusters/dev-cluster
resource "google_container_cluster" "dev" {
  name     = "dev-cluster"
  location = var.region
  project  = var.project_id
  network  = var.network

  initial_node_count       = 1
  remove_default_node_pool = true

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Node pool: projects/acme-prod-infra/locations/us-central1/clusters/dev-cluster/nodePools/dev-pool
resource "google_container_node_pool" "dev" {
  name     = "dev-pool"
  cluster  = google_container_cluster.dev.name
  location = var.region
  project  = var.project_id

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type    = "e2-standard-2"
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    labels = {
      pool = "dev"
    }

    tags = ["gke-node", "dev"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }
  }
}
