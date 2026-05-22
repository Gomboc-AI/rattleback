# Scenario: Azure Subnet NSG Association

- ID: 07
- Provider: Azure
- Category: Security
- Language: Terraform

## Why This Matters

An Azure subnet without a Network Security Group association has no inbound or outbound traffic filtering at the network layer. Traffic can flow freely between subnets, between VMs, and potentially to and from the internet — entirely determined by whatever other controls happen to exist at the VM or application level. This enables lateral movement: an attacker who compromises one workload in the subnet can scan and attack adjacent workloads without crossing any network boundary. Network segmentation is the structural defense that limits blast radius when a breach occurs.

## Business Case

NSG association on every subnet is a Level 1 CIS Microsoft Azure Foundations Benchmark control and is explicitly required for PCI-DSS network segmentation. For organizations running multi-tier applications (web, app, database layers), unassociated subnets defeat the purpose of the segmentation entirely — the tiers are logically separated but not enforced at the network level. A breach in the web tier should not mean automatic access to the database tier; without NSG enforcement, it does. For enterprises undergoing Azure security assessments or SOC 2 audits, missing NSG associations are a consistent finding that delays certification.

## Customer Productivity Impact

Azure's Terraform provider requires a separate association resource to link a subnet to an NSG — a non-obvious two-step pattern that is frequently omitted when engineers create new subnets quickly. Gomboc detects that the NSG exists but is not associated and generates the missing linkage resource automatically, requiring only the subnet's runtime ID from the engineer. Security teams get consistent enforcement across all subnets without relying on each engineer knowing the association pattern. Network policy is expressed in code and enforced at deploy time rather than discovered in a quarterly audit.
