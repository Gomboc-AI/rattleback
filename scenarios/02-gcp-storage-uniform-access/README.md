# Scenario: GCS Uniform Bucket-Level Access

- ID: 02
- Provider: GCP
- Category: Security
- Language: Terraform

## Why This Matters

When object-level access control lists (ACLs) are permitted on a storage bucket, individual files can carry their own hidden permissions that sit outside of — and override — the organization's central IAM policies. This creates invisible exceptions: a file can be publicly readable even if the bucket itself appears locked down. Security audits that check IAM policies alone will miss these object-level exceptions entirely, creating a false sense of coverage.

## Business Case

Uniform bucket-level access is required or strongly recommended by SOC 2, ISO 27001, and Google's own CIS GCP Benchmark. For organizations storing customer data, financial records, or intellectual property in GCS, ACL-based exceptions are an audit liability and a breach vector. Enforcing this policy ensures that every access decision is made in one place (IAM), is fully auditable, and cannot be bypassed by a misconfigured file upload. The compliance cost of not enforcing it — through a single data exposure incident — far exceeds the engineering effort of enabling it.

## Customer Productivity Impact

Engineering teams operating under this policy no longer need to reason about two overlapping permission systems. Security teams get a single, consistent access control plane across every object in every bucket, reducing audit prep time and eliminating entire categories of security review. Gomboc identifies and remediates this with a single automated code change — no manual bucket-by-bucket review, no one-off Terraform edits, no risk of drift.
