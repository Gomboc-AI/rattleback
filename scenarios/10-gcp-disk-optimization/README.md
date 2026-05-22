# Scenario: GCE Disk Type Migration (Hyperdisk Balanced)

- ID: 10
- Provider: GCP
- Category: Cost
- Language: Terraform

## Why This Matters

Cloud storage pricing for provisioned SSDs is based on capacity, not utilization. A 500 GB pd-ssd disk costs the same whether it processes 15,000 IOPS continuously or sits idle for six days straight. For a weekly batch workload that needs burst performance for four hours every Saturday, the organization is paying 168 hours per week for capacity it uses for only four — a 97% waste rate. Hyperdisk Balanced decouples storage capacity from IOPS provisioning, meaning organizations pay for peak performance only when they need it and can adjust IOPS dynamically without reprovisioning the disk.

## Business Case

Cloud cost optimization is consistently ranked among the top three cloud infrastructure priorities by CIOs and CFOs. The gap between what organizations provision and what they actually use — commonly called "cloud waste" — averages 30-35% of total cloud spend according to industry analysts. Storage overprovisioning is one of the largest contributors. For a single disk this example represents a meaningful monthly savings; across an enterprise with hundreds of compute workloads, the same pattern identified and remediated systematically can yield six-figure annual savings. Demonstrating measurable cost reduction also builds organizational trust in the infrastructure-as-code model itself.

## Customer Productivity Impact

FinOps teams typically identify overprovisioned storage through manual cost reviews or cloud provider recommendations — a reactive process that happens weeks or months after the waste has begun accumulating. Gomboc shifts this detection to the code layer: the misconfiguration is identified and remediated before the resource is ever deployed, eliminating the waste from day one. Engineers get the correct disk type and IOPS configuration automatically; they do not need to read GCP pricing documentation or understand the difference between pd-ssd and Hyperdisk Balanced attributes to get an optimal outcome.
