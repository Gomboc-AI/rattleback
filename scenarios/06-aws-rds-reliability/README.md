# Scenario: AWS RDS Multi-AZ + Automated Backups

- ID: 06
- Provider: AWS
- Category: Reliability
- Language: Terraform

## Why This Matters

A production database running in a single Availability Zone is a single point of failure with no automated recovery path. When an AZ becomes unavailable — due to hardware failure, power issues, or networking problems, all of which occur regularly in large cloud regions — a Single-AZ RDS instance simply stops responding. Without automated backups, the window for point-in-time recovery closes with every passing day. For a production system processing 50,000 orders per day, even a two-hour outage represents significant revenue loss, customer-facing errors, and operational scrambling.

## Business Case

AWS's own SLA for RDS Multi-AZ is 99.95% monthly uptime. Single-AZ RDS carries no such guarantee and provides no automatic failover. Multi-AZ deployment flips that equation: AWS handles failover automatically, typically in under two minutes, with no application changes required. The 7-day backup retention provides a recovery point objective that satisfies ISO 22301 (business continuity), SOC 2 Availability criteria, and most enterprise DR requirements. For a business whose revenue depends on database availability — e-commerce, SaaS, financial services — the cost of Multi-AZ (roughly a 2× instance price) is trivially small relative to the cost of a single outage or data loss incident.

## Customer Productivity Impact

Engineering teams that operate without Multi-AZ often develop elaborate manual failover runbooks, alerting stacks, and on-call escalation procedures to compensate for what is a one-line infrastructure change. Gomboc detects this gap and generates the complete fix — Multi-AZ, retention period, and backup window — in a single automated code change. Operations teams gain an SLA backed by AWS infrastructure rather than human response time. On-call engineers are no longer responsible for a class of incidents that should never require human intervention.
