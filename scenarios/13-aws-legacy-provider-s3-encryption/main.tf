# S3 bucket: arn:aws:s3:::acme-billing-exports-2024
resource "aws_s3_bucket" "billing_exports" {
  bucket = "acme-billing-exports-2024"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "expire-old-exports"
    enabled = true

    expiration {
      days = 2555
    }
  }

  tags = {
    Name        = "Billing Exports Archive"
    Environment = "production"
    Team        = "finance"
    CostCenter  = "fin-4001"
  }
}

# S3 bucket: arn:aws:s3:::acme-legal-archives-2024
resource "aws_s3_bucket" "legal_archives" {
  bucket = "acme-legal-archives-2024"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.kms_key_arn
      }
      bucket_key_enabled = true
    }
  }

  tags = {
    Name        = "Legal Archives"
    Environment = "production"
    Team        = "legal"
  }
}
