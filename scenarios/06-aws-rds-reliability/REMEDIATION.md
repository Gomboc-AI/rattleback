# Remediation Request

**Category:** Reliability

## Finding

RDS instance `arn:aws:rds:us-west-2:123456789012:db:acme-orders-db` is a production database handling approximately 50,000 orders per day. It is deployed in a Single-AZ configuration with no automated backups enabled. This means any AZ failure will cause downtime, and there is no point-in-time recovery capability.

## Required Action

Enable Multi-AZ deployment on `arn:aws:rds:us-west-2:123456789012:db:acme-orders-db`, set backup retention to 7 days, and configure the preferred backup window to 03:00-04:00 UTC.
