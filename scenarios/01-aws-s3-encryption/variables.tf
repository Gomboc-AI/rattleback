variable "region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "acme-analytics-raw-2024"
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for S3 server-side encryption"
  type        = string
  default     = "arn:aws:kms:us-east-1:123456789012:key/abcd-1234-efgh-5678"
}
