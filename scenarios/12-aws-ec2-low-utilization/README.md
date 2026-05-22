# Scenario: AWS EC2 Right-Sizing + Scheduling

- ID: 12
- Provider: AWS
- Category: Cost
- Language: Terraform

## Why This Matters

EC2 instances accrue charges 24 hours a day, 7 days a week, regardless of whether they are doing useful work. The dev sandbox in this scenario averages 3.8% CPU utilization across two weeks — it is running at roughly 4% of its purchased capacity continuously. The ETL instance is appropriately sized for its Saturday burst job but runs at near-zero utilization the other six days. Together they cost ~$870/month at On-Demand rates, of which the vast majority represents pure waste. Trusted Advisor flagged them — the finding existed — but without automated remediation, they continue running until an engineer takes action. That gap between "flagged" and "fixed" is where cloud waste accumulates.

## Business Case

AWS Trusted Advisor and Cost Explorer surface underutilized instances for every AWS customer, but surfacing a finding and acting on it are different things. Industry data consistently shows that the average time from a cost optimization finding to remediation is measured in weeks or months — during which the waste continues. At $870/month for two instances, the delay cost is significant; across an enterprise with hundreds of flagged instances, it is a major budget line. The business case for automated remediation is straightforward: reduce the gap between detection and action to hours, and do it without requiring manual engineering effort for every finding. For the ETL instance specifically, scheduling automation can reduce its monthly cost by 85% while preserving 100% of its performance during the run window.

## Customer Productivity Impact

This scenario demonstrates something particularly important: Gomboc applies differentiated remediation strategies based on the workload context. It does not apply a one-size-fits-all "downsize everything" approach. The dev sandbox gets right-sized because its utilization pattern confirms overprovisioning. The ETL instance keeps its instance type because resizing it would break the Saturday batch job — instead it gets scheduled for automatic shutdown when idle. This kind of contextual judgment, encoded in policy rules that can be applied at scale across hundreds of instances, is what separates automated cloud optimization from naive cost-cutting. FinOps teams get actionable, context-aware code changes; engineering teams do not need to re-evaluate each instance individually.
