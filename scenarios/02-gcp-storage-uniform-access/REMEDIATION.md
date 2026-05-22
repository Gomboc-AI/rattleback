# Remediation Request

**Category:** Security

## Finding

Bucket `gs://acme-prod-data-lake-7f3a` has ACL-based access control enabled. This means individual objects can have their own ACL permissions, which increases the risk of unintended access and makes auditing more difficult.

## Required Action

Enable uniform bucket-level access on `gs://acme-prod-data-lake-7f3a`. This ensures all access is managed exclusively through IAM policies, eliminating per-object ACLs and simplifying permission management.
