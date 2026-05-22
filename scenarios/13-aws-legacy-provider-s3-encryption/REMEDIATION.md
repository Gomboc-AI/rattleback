# Remediation Request

**Category:** Security

## Finding

S3 bucket `arn:aws:s3:::acme-billing-exports-2024` does not have default server-side encryption configured. Data at rest in this bucket is not protected by a customer-managed encryption key.

## Required Action

Enable default SSE-KMS encryption on bucket `acme-billing-exports-2024` using KMS key `arn:aws:kms:us-east-1:123456789012:key/1234abcd-12ab-34cd-56ef-1234567890ab`. All new objects written to the bucket should be encrypted automatically with this key.
