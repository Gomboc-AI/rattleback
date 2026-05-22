# GCE instance: projects/acme-prod-infra/zones/us-central1-a/instances/batch-worker-1
resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = "n2-standard-8"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 50
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = "projects/${var.project_id}/global/networks/default"
    subnetwork = "projects/${var.project_id}/regions/us-central1/subnetworks/default"
  }

  tags = ["batch-processing", "internal-only"]

  labels = {
    environment = "production"
    team        = "data-engineering"
    workload    = "batch"
    cost-center = "de-1042"
    schedule    = "weekly-saturday"
  }

  metadata = {
    enable-oslogin = "true"
  }

  service_account {
    email  = "batch-worker@acme-prod-infra.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
}

# Persistent disk: projects/acme-prod-infra/zones/us-central1-a/disks/batch-data-ssd
resource "google_compute_disk" "main" {
  name    = var.disk_name
  type    = "pd-ssd"
  size    = 500
  zone    = var.zone
  project = var.project_id

  labels = {
    environment = "production"
    team        = "data-engineering"
    workload    = "batch"
    cost-center = "de-1042"
  }

  physical_block_size_bytes = 4096
}

# Disk attachment: batch-worker-1 <-> batch-data-ssd
resource "google_compute_attached_disk" "main" {
  disk     = google_compute_disk.main.id
  instance = google_compute_instance.main.id
  zone     = var.zone
  project  = var.project_id
  mode     = "READ_WRITE"
}

# GCE instance: projects/acme-prod-infra/zones/us-central1-a/instances/analytics-worker-1
resource "google_compute_instance" "analytics" {
  name         = "analytics-worker-1"
  machine_type = "c3-standard-8"
  zone         = var.zone
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
      size  = 50
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = "projects/${var.project_id}/global/networks/default"
    subnetwork = "projects/${var.project_id}/regions/us-central1/subnetworks/default"
  }

  tags = ["analytics", "internal-only"]

  labels = {
    environment = "production"
    team        = "data-analytics"
    workload    = "analytics"
    cost-center = "da-2087"
  }

  metadata = {
    enable-oslogin = "true"
  }

  service_account {
    email  = "analytics-worker@acme-prod-infra.iam.gserviceaccount.com"
    scopes = ["cloud-platform"]
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  lifecycle {
    ignore_changes = [attached_disk]
  }
}

# Persistent disk: projects/acme-prod-infra/zones/us-central1-a/disks/analytics-data
resource "google_compute_disk" "analytics" {
  name    = "analytics-data"
  type    = "pd-standard"
  size    = 200
  zone    = var.zone
  project = var.project_id

  labels = {
    environment = "production"
    team        = "data-analytics"
    workload    = "analytics"
    cost-center = "da-2087"
  }

  physical_block_size_bytes = 4096
}

# Disk attachment: analytics-worker-1 <-> analytics-data
resource "google_compute_attached_disk" "analytics" {
  disk     = google_compute_disk.analytics.id
  instance = google_compute_instance.analytics.id
  zone     = var.zone
  project  = var.project_id
  mode     = "READ_WRITE"
}
