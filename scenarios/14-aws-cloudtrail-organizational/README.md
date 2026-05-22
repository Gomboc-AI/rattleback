# Scenario: AWS CloudTrail Organizational Consolidation

- ID: 14
- Provider: AWS
- Category: Cost
- Language: Terraform

## Why This Matters

Running three independent CloudTrail management trails across an AWS organization creates duplicated audit records, fragmented visibility, and unnecessary cost — without providing any additional security value. Each trail captures identical events into separate S3 buckets, meaning a security analyst investigating an incident must query three separate systems to reconstruct a complete picture. The per-account trail setup was a common pattern before AWS introduced organizational trails; it is now a legacy anti-pattern that persists primarily because no one has prioritized cleaning it up. Meanwhile, the organization pays $1,450/month in CloudTrail recording fees and approximately $600/month in redundant S3 storage.

## Business Case

The $2,050/month ($24,600/year) in direct savings for this one organization is meaningful, but the more significant business case is operational. A single organizational trail provides a unified audit log for the entire AWS organization — a single system to query, a single retention policy to manage, and a single bucket to protect and monitor. This directly reduces the cost of compliance reporting (SOC 2, PCI-DSS, ISO 27001 all require audit log management), incident response (faster, more complete investigation from one source of truth), and ongoing infrastructure maintenance (fewer resources to manage, fewer bucket policies to audit). For enterprises with dozens of AWS accounts, this same consolidation pattern can save hundreds of thousands annually while simultaneously improving security operations.

## Customer Productivity Impact

This scenario is particularly compelling as a demonstration of Gomboc's capability because it requires the most complex set of coordinated changes in the test suite: modifying IAM policies, updating trail configuration, adjusting S3 path patterns, and removing ten interdependent resources — all while preserving an unrelated trail that must not be touched. This is the kind of change that takes an experienced cloud engineer a full day to plan, implement, and validate safely. Gomboc generates the complete, correct implementation in a single automated pass, with the PCI trail preservation handled correctly without any special instruction. Engineering teams redirect that day of effort to higher-value work; finance teams see an immediate, measurable monthly cost reduction.
