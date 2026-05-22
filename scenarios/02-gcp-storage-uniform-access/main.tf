# GCS bucket: gs://acme-prod-data-lake-7f3a
resource "google_storage_bucket" "main" {
  name          = var.bucket_name
  project       = var.project_id
  location      = var.region
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    environment = "production"
    team        = "data-engineering"
    cost-center = "de-1042"
  }
}

# IAM binding: gs://acme-prod-data-lake-7f3a (objectViewer → data-pipeline SA)
resource "google_storage_bucket_iam_member" "data_pipeline_reader" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:data-pipeline@acme-prod-infra.iam.gserviceaccount.com"
}

# GCS bucket: gs://acme-prod-audit-logs-9b2c
resource "google_storage_bucket" "audit" {
  name          = "acme-prod-audit-logs-9b2c"
  project       = var.project_id
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  labels = {
    environment = "production"
    team        = "security"
  }
}
