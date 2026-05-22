# Scenario: GCP Cloud SQL SSL + Authorized Networks

- ID: 08
- Provider: GCP
- Category: Security
- Language: Terraform

## Why This Matters

A Cloud SQL instance with require_ssl = false transmits database credentials and query results — including any sensitive data in query responses — in plaintext over the network. A Cloud SQL instance with authorized_networks = 0.0.0.0/0 accepts connections from any IP address on the public internet. Together, these two misconfigurations mean that anyone on the internet can attempt to connect to the database and, if they succeed, their entire session is unencrypted. Shodan and similar tools continuously index internet-exposed databases; the time between exposure and first connection attempt is measured in minutes.

## Business Case

HIPAA explicitly requires encryption in transit for protected health information traversing any network. PCI-DSS requires both encryption in transit and network access controls for cardholder data environments. For SaaS companies storing customer data in Cloud SQL — the majority of GCP-hosted database workloads — these two controls together represent the minimum viable security baseline. The reputational and regulatory cost of a database breach from an unencrypted, publicly accessible instance is severe: GDPR fines alone can reach 4% of global annual revenue. The fix is a two-line code change.

## Customer Productivity Impact

The authorized networks misconfiguration in this scenario was particularly subtle: the variable-driven dynamic block looked correct in isolation, but its runtime value exposed the database to the world. Gomboc detects the effective security posture — not just the structural syntax — and generates a fix that enforces the intended network restriction. Engineering teams get infrastructure that is correctly locked down by default, without requiring every developer to understand the interaction between Terraform dynamic blocks and Cloud SQL's network policy evaluation.
