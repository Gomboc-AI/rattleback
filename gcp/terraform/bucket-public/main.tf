resource "google_storage_bucket" "uut" {
  name          = var.bucket_name_chris_test
  location      = var.bucket_location
  force_destroy = true
  break this
}
resource "google_storage_bucket_iam_member" "uut" {
  bucket = google_storage_bucket.uut.name
  role   = var.role
  member = "allUsers"
}
