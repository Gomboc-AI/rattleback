# Scenario: AWS VPC Endpoints (NAT Gateway Traffic Bypass)

- ID: 15
- Provider: AWS
- Category: Security, Cost
- Language: Terraform

## Why This Matters

This scenario illustrates a billing anti-pattern that is extremely common but rarely detected because it requires combining network topology knowledge, cost analysis, and infrastructure code review simultaneously. Traffic from private EC2 instances to AWS services like S3, DynamoDB, SQS, and ECR takes a path through NAT gateways by default — adding $0.045/GB in data transfer charges to every byte, even though both source and destination are within AWS's own network. VPC endpoints create a private routing path that eliminates those charges entirely for Gateway endpoints (S3, DynamoDB) and reduces them significantly for Interface endpoints. Beyond cost, routing internal AWS-to-AWS traffic through the public internet is a security anti-pattern: it adds an unnecessary public egress surface for data that should never leave the AWS network.

## Business Case

The $166/month in this single VPC represents a straightforward ROI calculation, but the real business case is scale. Large organizations with dozens of VPCs, high-volume data pipelines, container workloads pulling images from ECR, and event-driven architectures using SQS can see NAT gateway data transfer costs in the tens of thousands of dollars per month from this pattern alone. VPC endpoints are free (for Gateway endpoints) or low-cost (for Interface endpoints), with a payback period measured in days. This is also a security improvement: eliminating public egress for internal AWS traffic closes a potential data exfiltration pathway and simplifies network egress monitoring.

## Customer Productivity Impact

The VPC endpoint pattern requires creating multiple interdependent resources — security groups, endpoint resources, route table associations — and selecting the correct endpoint type (Gateway vs. Interface) for each AWS service. Getting this right requires reading service-specific documentation and understanding the routing implications. Gomboc generates the complete, architecturally correct endpoint configuration from a single finding, producing 107 lines of validated Terraform. Engineers fill in the region (4 values) and deploy. FinOps teams see an immediate, measurable cost reduction that compounds as traffic volume grows.
