# Scenario: AWS S3 Legacy Provider Encryption (Inline Syntax)

- ID: 13
- Provider: AWS
- Category: Security
- Language: Terraform

## Why This Matters

Legacy infrastructure — code written against older versions of Terraform providers before encryption configuration was split into its own resource type — is the most common blind spot in cloud security programs. Modern security scanners look for aws_s3_bucket_server_side_encryption_configuration as a separate resource; they do not flag its absence from the legacy inline syntax, because the bucket resource itself looks structurally valid. This means billing export data — which often contains account numbers, vendor invoices, usage details, and organizational spending patterns — sits unencrypted, invisible to the security tooling that should be protecting it.

## Business Case

Billing export data is sensitive financial information. In regulated industries, it falls under data classification policies requiring encryption at rest. Beyond compliance, an exposed billing export reveals detailed information about an organization's cloud architecture, vendor relationships, and usage patterns — intelligence that is directly valuable to competitors and attackers performing reconnaissance. The fact that this bucket is a billing export specifically also means it is likely subject to financial data retention requirements, making a breach incident more costly in terms of notification and remediation obligations. Gomboc's ability to detect both the legacy and modern encryption patterns ensures that no bucket — regardless of when it was written — falls through the gap.

## Customer Productivity Impact

Organizations that have grown their cloud infrastructure over multiple years often have a patchwork of Terraform code written against different provider versions. Periodic provider upgrades do not automatically backfill encryption on existing resources. Security teams conducting manual audits frequently miss the legacy pattern for the same reason automated tools do. Gomboc handles both idioms — automatically selecting the correct fix pattern based on what exists in the code — so engineering teams do not need to audit provider versions or understand the historical evolution of the AWS provider's S3 resource schema.
