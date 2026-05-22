# Scenario: AWS EKS Multi-AZ Expansion

- ID: 11
- Provider: AWS
- Category: Reliability
- Language: Terraform

## Why This Matters

A production Kubernetes cluster operating across only two Availability Zones means that any AZ failure immediately takes out 50% of cluster capacity. Under normal load, the remaining 50% may be insufficient to absorb the traffic — triggering an outage that would not have occurred with three-AZ distribution. AWS availability events, while rare, do occur multiple times per year across the global infrastructure, and the failure modes are unpredictable. The AWS Well-Architected Framework explicitly recommends three-AZ deployment for all production workloads precisely because two-AZ provides insufficient resilience at scale.

## Business Case

For SaaS companies operating with uptime SLAs (99.9%, 99.95%, or higher), a single AZ failure that triggers a partial outage can immediately put them out of compliance with customer contracts, triggering SLA credits or worse. For platforms that process financial transactions, customer orders, or healthcare data, the regulatory and contractual implications compound the technical impact. Additionally, the Savings Plan optimization in this scenario — expanding Karpenter's instance selection to cover c5.2xlarge and m5.2xlarge in the new zone — ensures that the expanded capacity is procured against existing committed spend rather than at on-demand rates, maximizing return on the cloud commitment already made.

## Customer Productivity Impact

Expanding an EKS cluster to a third AZ requires coordinated changes across multiple systems: VPC subnets, node group configurations, autoscaler settings, and workload scheduling policies. Missing any one of these touch points can result in nodes provisioned in the new AZ being unable to schedule workloads, partially defeating the purpose of the expansion. Gomboc identifies and applies all required changes in a single pass — the platform team gets a complete, consistent expansion rather than a partially implemented one discovered during the next incident.
