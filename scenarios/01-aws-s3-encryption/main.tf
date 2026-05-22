# S3 bucket: arn:aws:s3:::acme-analytics-raw-2024
resource "aws_s3_bucket" "analytics" {
  bucket = var.bucket_name

  tags = {
    Name        = "Analytics Raw Data"
    Environment = "production"
    Team        = "data-science"
    CostCenter  = "ds-2087"
  }
}

# Versioning config for arn:aws:s3:::acme-analytics-raw-2024
resource "aws_s3_bucket_versioning" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Public access block for arn:aws:s3:::acme-analytics-raw-2024
resource "aws_s3_bucket_public_access_block" "analytics" {
  bucket = aws_s3_bucket.analytics.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 bucket: arn:aws:s3:::acme-analytics-processed-2024
resource "aws_s3_bucket" "processed" {
  bucket = "acme-analytics-processed-2024"
  tags = {
    Name        = "Analytics Processed Data"
    Environment = "production"
    Team        = "data-science"
  }
}

# Encryption for arn:aws:s3:::acme-analytics-processed-2024
resource "aws_s3_bucket_server_side_encryption_configuration" "processed" {
  bucket = aws_s3_bucket.processed.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
    bucket_key_enabled = true
  }
}
