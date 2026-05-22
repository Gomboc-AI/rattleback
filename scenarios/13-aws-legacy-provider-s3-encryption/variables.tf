variable "kms_key_arn" {
  description = "KMS key ARN used for S3 default encryption"
  type        = string
  default     = "arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab"
}
