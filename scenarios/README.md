# Rattleback Policy Scenarios

This directory contains Terraform-based policy remediation scenarios used to demonstrate Gomboc detection and automated fixes across cloud providers and workload types. Each scenario includes violation code, remediation guidance, and business context in its own `README.md`.

## Scenario Index

| ID | Title | Category | Provider | Language | Description |
|----|-------|----------|----------|----------|-------------|
| [01](01-aws-s3-encryption/) | AWS S3 SSE-KMS Encryption | Security | AWS | Terraform | Remediates S3 buckets missing server-side encryption so data at rest is protected with customer-managed KMS keys. |
| [02](02-gcp-storage-uniform-access/) | GCS Uniform Bucket-Level Access | Security | GCP | Terraform | Enforces uniform bucket-level access on GCS buckets to eliminate object-level ACLs that bypass central IAM policies. |
| [03](03-k8s-resource-limits/) | Kubernetes Resource Limits | Reliability | Kubernetes | Terraform | Adds CPU and memory requests and limits to containers so workloads cannot exhaust shared cluster resources. |
| [04](04-aws-sg-restrict-ingress/) | AWS Security Group SSH Ingress Restriction | Security | AWS | Terraform | Restricts security group SSH ingress from the open internet to approved corporate CIDR ranges. |
| [05](05-gcp-gke-workload-identity/) | GCP GKE Workload Identity + Shielded Nodes | Security | GCP | Terraform | Enables Workload Identity and Shielded Nodes on GKE clusters for per-pod GCP identity and hardware-rooted node trust. |
| [06](06-aws-rds-reliability/) | AWS RDS Multi-AZ + Automated Backups | Reliability | AWS | Terraform | Configures Multi-AZ deployment and automated backups on RDS instances to survive AZ failures and enable point-in-time recovery. |
| [07](07-azure-subnet-nsg/) | Azure Subnet NSG Association | Security | Azure | Terraform | Associates Network Security Groups with subnets so inbound and outbound traffic is filtered at the network layer. |
| [08](08-gcp-cloudsql-ssl/) | GCP Cloud SQL SSL + Authorized Networks | Security | GCP | Terraform | Requires SSL for Cloud SQL connections and restricts authorized networks so databases are not exposed on the public internet. |
| [09](09-k8s-statefulset-image/) | Kubernetes StatefulSet Image Update | Security | Kubernetes | Terraform | Updates a StatefulSet container image to patch known Redis CVEs in production caching workloads. |
| [10](10-gcp-disk-optimization/) | GCE Disk Type Migration (Hyperdisk Balanced) | Cost | GCP | Terraform | Migrates overprovisioned pd-ssd disks to Hyperdisk Balanced to decouple capacity from IOPS and reduce storage waste. |
| [11](11-aws-eks-nodepool-ha/) | AWS EKS Multi-AZ Expansion | Reliability | AWS | Terraform | Expands an EKS cluster to a third Availability Zone with coordinated subnet, node pool, and autoscaler changes. |
| [12](12-aws-ec2-low-utilization/) | AWS EC2 Right-Sizing + Scheduling | Cost | AWS | Terraform | Right-sizes underutilized dev instances and schedules batch ETL instances to cut EC2 spend without breaking workload patterns. |
| [13](13-aws-legacy-provider-s3-encryption/) | AWS S3 Legacy Provider Encryption (Inline Syntax) | Security | AWS | Terraform | Adds encryption to S3 buckets defined with legacy inline provider syntax that modern scanners often miss. |
| [14](14-aws-cloudtrail-organizational/) | AWS CloudTrail Organizational Consolidation | Cost | AWS | Terraform | Consolidates redundant per-account CloudTrail trails into a single organizational trail to cut cost and unify audit logs. |
| [15](15-aws-vpc-nat-endpoints/) | AWS VPC Endpoints (NAT Gateway Traffic Bypass) | Security, Cost | AWS | Terraform | Adds VPC endpoints so private traffic to AWS services bypasses NAT gateways, reducing data transfer cost and public egress. |

## Using a Scenario

Each subdirectory is a self-contained Terraform workspace:

1. Open the scenario folder and read its `README.md` for policy context and business rationale.
2. Review `main.tf` for the intentional violation pattern.
3. Follow `REMEDIATION.md` (where present) or apply Gomboc remediation to reach the compliant state.

## Provider Coverage

| Provider | Scenarios |
|----------|-----------|
| AWS | 01, 04, 06, 11, 12, 13, 14, 15 |
| GCP | 02, 05, 08, 10 |
| Azure | 07 |
| Kubernetes | 03, 09 |
