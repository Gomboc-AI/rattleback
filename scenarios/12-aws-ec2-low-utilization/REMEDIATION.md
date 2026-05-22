# Remediation Request

**Category:** Cost

## Finding

AWS Trusted Advisor's **Low Utilization Amazon EC2 Instances** check flagged the following instances in account `123456789012`, region `us-east-1`, for the 14-day window ending today: daily-average CPU ≤ 10% and daily network I/O ≤ 5 MB on at least 4 of the 14 days.

| Instance ARN | Instance type | 14-day avg CPU | 14-day avg Net I/O | Days flagged |
|--------------|---------------|----------------|--------------------|--------------|
| `arn:aws:ec2:us-east-1:123456789012:instance/i-0aa11bb22cc33dd44` | `m5.2xlarge` | 3.8% | 1.2 MB | 14 of 14 |
| `arn:aws:ec2:us-east-1:123456789012:instance/i-0cc33dd44ee55ff66` | `c5.4xlarge` | 7.4% | 3.9 MB | 12 of 14 |

Both instances carry On-Demand hourly charges 24×7. Estimated monthly spend at On-Demand rates for these two alone is ~$870/mo (m5.2xlarge ~$280/mo, c5.4xlarge ~$590/mo).

Resource context:
- `i-0aa11bb22cc33dd44` (tag `Name=acme-dev-sandbox`): a persistent developer sandbox box that has been sized for a workload that never materialised. It has user data on its root EBS volume (notebooks, model artefacts) that the team wants to keep.
- `i-0cc33dd44ee55ff66` (tag `Name=acme-weekly-etl`): a **weekly** ETL worker — it idles 6 days a week and runs at ~95% CPU every Saturday 02:00–06:00 UTC (tag `Schedule=saturday-02-06-utc`). The 14-day window aggregates to a low daily average, but the instance is load-bearing during its run window and was sized for that burst.


## Required Action

Reduce the over-provisioning on these instances without losing data or breaking scheduled workloads.
Propose the most cost-effective remediation for each flagged instance that preserves the workload's requirements.
