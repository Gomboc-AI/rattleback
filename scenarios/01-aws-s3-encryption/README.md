# Scenario: AWS S3 SSE-KMS Encryption

- ID: 01
- Provider: AWS
- Category: Security
- Language: Terraform

## Why This Matters

An S3 bucket without server-side encryption stores data in plaintext on AWS infrastructure. A misconfigured bucket policy, an overly permissive IAM role, or a compromised credential can expose that data directly. Encryption at rest is the last line of defense — it ensures that even if an attacker gains access to the raw storage layer, the data is unreadable without the encryption key. High-profile S3 breaches (Capital One, Twitch, others) have repeatedly demonstrated that "access controls will protect us" is insufficient.

## Business Case

Server-side encryption with customer-managed KMS keys (SSE-KMS) is a mandatory control under HIPAA (for protected health information), PCI-DSS (for cardholder data), FedRAMP, and SOC 2. For organizations pursuing enterprise customers or government contracts, this is a non-negotiable checkbox in every security questionnaire. Beyond compliance, it also enables fine-grained key access auditing through AWS CloudTrail — every decryption operation is logged, enabling forensic investigation of data access. The business risk of a plaintext data breach — regulatory fines, customer notification requirements, reputational damage — is orders of magnitude higher than the cost of enabling encryption.

## Customer Productivity Impact

Without automation, ensuring every S3 bucket across an organization has SSE-KMS configured requires manual audits, engineering tickets, and follow-up verification — a process that scales poorly as infrastructure grows. Gomboc detects the gap in code before it reaches production and generates the complete Terraform configuration, requiring only that the engineer supplies the KMS key ARN. The engineer makes one targeted decision (which key to use); the structural implementation is handled automatically. This compresses what was a multi-step review-and-remediation cycle into a single, reviewable code change.
