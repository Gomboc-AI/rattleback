# Scenario: AWS Security Group SSH Ingress Restriction

- ID: 04
- Provider: AWS
- Category: Security
- Language: Terraform

## Why This Matters

A security group that allows inbound SSH (port 22) from 0.0.0.0/0 exposes server login to the entire internet. Automated scanners continuously probe the internet for open port 22, and a single weak or reused credential means full server access. This is one of the most well-documented and consistently exploited misconfigurations in cloud infrastructure — it appears in breach reports, pen test findings, and compliance audit failures year after year, across every organization and every cloud provider.

## Business Case

Unrestricted SSH ingress violates PCI-DSS Requirement 1 (network access controls), CIS AWS Foundations Benchmark, SOC 2 CC6.6, and virtually every enterprise security baseline. Cyber insurance underwriters now explicitly check for open SSH in their questionnaires, and coverage can be denied or premiums increased for organizations found to have it. Beyond compliance, a compromised bastion or jump host creates a pivot point for lateral movement — the AWS blast radius from a single stolen SSH key can span accounts, regions, and VPCs.

## Customer Productivity Impact

Security teams spend significant time reviewing security group configurations during audits and incident response. Gomboc catches this class of misconfiguration in code before it is ever deployed, eliminating the gap between "infrastructure deployed" and "security reviewed." When a policy already exists defining the allowed corporate CIDR, engineers do not need to remember to apply it — the automation ensures it is enforced consistently. The result is fewer findings in external pen tests, faster compliance audits, and a security posture that improves with each infrastructure change rather than eroding over time.
