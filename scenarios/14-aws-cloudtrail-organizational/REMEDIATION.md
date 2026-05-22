# Remediation Request

**Category:** Cost

## Finding

Our AWS organization (`o-abc1234xyz`, management account `111111111111`) currently runs independent management-event CloudTrails in each account:

- `arn:aws:cloudtrail:us-east-1:111111111111:trail/acme-mgmt-audit` — management account only
- `arn:aws:cloudtrail:us-east-1:222222222222:trail/acme-prod-audit` — member account `acme-prod`
- `arn:aws:cloudtrail:us-east-1:333333333333:trail/acme-data-audit` — member account `acme-data`

All three capture the same categories of events (multi-region management events, global service events, log file validation) into separate per-account S3 buckets:

- `arn:aws:s3:::acme-mgmt-audit-logs-111111111111`
- `arn:aws:s3:::acme-prod-audit-logs-222222222222`
- `arn:aws:s3:::acme-data-audit-logs-333333333333`

Over the last 3 months, this duplicated setup billed $$1,450/mo in CloudTrail event recording plus ~$600/mo in S3 storage across the three buckets. CloudTrail's first management-event copy per account is free, but we are paying for the management account copy plus continuing to run per-member trails that produce the same audit record.

## Required Action

Consolidate management event logging into a single organizational trail owned by the management account (`111111111111`). The organizational trail automatically captures management events from every account in the organization into one bucket at no per-member cost. Retire the per-member duplicate trails and their dedicated logging buckets.

Preserve the existing S3 bucket that fronts the management-account trail (`arn:aws:s3:::acme-mgmt-audit-logs-111111111111`) and use it as the organizational trail's destination — update the bucket policy as needed so CloudTrail in every member account can write its logs there.

## Out of Scope — Do Not Consolidate

There is a separate compliance trail in account `222222222222`:

- `arn:aws:cloudtrail:us-east-1:222222222222:trail/acme-pci-data-events`

This trail captures S3 object-level (data) events on the PCI-regulated bucket `arn:aws:s3:::acme-pci-regulated-data`, not management events. It must remain in place, in the member account, with its existing destination bucket. Our PCI-DSS v4 auditors require the data-event log stream to stay isolated from the general organization audit feed.
