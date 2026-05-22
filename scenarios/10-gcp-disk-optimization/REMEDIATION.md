# Remediation Request

**Category:** Cost

## Finding

GCE instance `projects/acme-prod-infra/zones/us-central1-a/instances/batch-worker-1` has attached disk `projects/acme-prod-infra/zones/us-central1-a/disks/batch-data-ssd` (pd-ssd, 500GB). The disk is idle (< 5 IOPS) 99% of the week but requires 15,000 random IOPS and 240 MB/s throughput for a weekly batch job (Saturdays 02:00-06:00 UTC).

## Required Action

Optimize cost for this burst usage pattern by migrating to Hyperdisk Balanced, which supports provisioned IOPS that can be dynamically adjusted.
