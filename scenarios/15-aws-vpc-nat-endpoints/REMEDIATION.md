# Remediation Request

**Category:** Cost

## Finding

Our production VPC `vpc-0abc123def456789a` (CIDR `10.42.0.0/16`, region `us-east-1`, account `123456789012`) runs three NAT gateways for high-availability egress:

- `nat-01a2b3c4d5e6f7890` (us-east-1a)
- `nat-11a2b3c4d5e6f7891` (us-east-1b)
- `nat-21a2b3c4d5e6f7892` (us-east-1c)

Based on the last 30 days of VPC flow logs and CloudWatch NAT gateway metrics, egress through these NAT gateways is billed at $0.045/GB as **NatGateway-Bytes**:

| Traffic | Volume (30d) | Destination type |
|---------|--------------|------------------|
| S3 bucket `arn:aws:s3:::acme-analytics-us-east-1` | ~2.1 TB | AWS, same region |
| DynamoDB table `arn:aws:dynamodb:us-east-1:123456789012:table/acme-orders` | ~0.4 TB | AWS, same region |
| SQS queue `arn:aws:sqs:us-east-1:123456789012:acme-order-events` | ~0.3 TB | AWS, same region |
| ECR image pulls from `123456789012.dkr.ecr.us-east-1.amazonaws.com` | ~0.9 TB | AWS, same region |
| CloudWatch Logs `PutLogEvents` against `logs.us-east-1.amazonaws.com` | ~0.8 TB | AWS, same region |
| KMS `Decrypt` against `kms.us-east-1.amazonaws.com` | ~0.01 TB | AWS, same region |
| Third-party API calls to `api.stripe.com` | ~0.1 TB | Internet (third-party) |
| S3 bucket `arn:aws:s3:::acme-archive-us-west-2` (legacy cross-region sync) | ~0.3 TB | AWS, **different region** (us-west-2) |
| **Total through NAT** | **~6.2 TB/mo** | **~$279/mo data processing** |

Approximately 72% of this traffic is AWS-bound and within the same region as the VPC. Because VPC ↔ AWS traffic via VPC endpoints does not incur data-transfer charges and gateway endpoints have no per-GB cost, most of this spend is avoidable.

## Required Action

Route same-region AWS-bound traffic off the NAT gateway path by adding VPC endpoints scoped to the workload subnets:

- Gateway endpoint for **S3** — associate with every private-subnet route table so same-region S3 traffic is routed directly via the endpoint.
- Gateway endpoint for **DynamoDB** — same route-table association requirement.
- Interface endpoints (PrivateLink) for **SQS**, **ECR API** (`com.amazonaws.us-east-1.ecr.api`), **ECR DKR** (`com.amazonaws.us-east-1.ecr.dkr`), **CloudWatch Logs**, and **KMS**. Provision each endpoint in all three private-subnet AZs used by the workload and enable private DNS so existing code continues to reach the services through their default hostnames.
- Put the interface endpoints behind a security group that allows TCP/443 from the VPC CIDR only.

## Out of Scope / Constraints

- Internet-bound traffic to `api.stripe.com` must continue to exit through the NAT gateways. No VPC endpoint exists for third-party internet services.
- The legacy cross-region sync to `arn:aws:s3:::acme-archive-us-west-2` will keep going through the NAT gateway — the S3 gateway endpoint in this VPC is regional and only routes traffic bound for S3 buckets in `us-east-1`. Do not attempt to tunnel cross-region S3 through this endpoint.
- The existing NAT gateways and their private-subnet default routes must remain in place so that non-AWS egress continues to work.
