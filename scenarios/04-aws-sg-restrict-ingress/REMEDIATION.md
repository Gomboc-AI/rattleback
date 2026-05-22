# Remediation Request

**Category:** Security

## Finding

Security group `arn:aws:ec2:us-west-2:123456789012:security-group/sg-0abc123def456` attached to instance `arn:aws:ec2:us-west-2:123456789012:instance/i-0fedcba987654` allows inbound SSH (port 22) from `0.0.0.0/0`. This exposes the SSH service to the entire internet, significantly increasing the risk of brute-force attacks and unauthorized access.

## Required Action

Restrict the SSH ingress rule on security group `arn:aws:ec2:us-west-2:123456789012:security-group/sg-0abc123def456` to allow connections only from the corporate network `10.0.0.0/8`.
