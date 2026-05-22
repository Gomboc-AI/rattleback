# Scenario: GCP GKE Workload Identity + Shielded Nodes

- ID: 05
- Provider: GCP
- Category: Security
- Language: Terraform

## Why This Matters

Without Workload Identity, every pod running on a Kubernetes node inherits the node's GCP service account — meaning any container on that node can call any GCP API the node has permission to, regardless of which application it belongs to. A compromised or misbehaving container gains access to production storage, databases, and secrets it should never touch. Shielded Nodes add a hardware-rooted trust chain: Secure Boot prevents rootkits and firmware-level attacks, while Integrity Monitoring verifies that the node's boot sequence has not been tampered with. Together, these two features represent the baseline for running production Kubernetes workloads with enterprise-grade security.

## Business Case

Workload Identity is a prerequisite for passing the CIS GKE Benchmark and is explicitly required in several enterprise customer security questionnaires for GCP workloads. Without it, organizations cannot demonstrate workload-level access isolation — a growing requirement in zero-trust architecture assessments. Shielded Nodes address supply chain risk at the infrastructure layer, which has become a board-level concern since the SolarWinds and SUNBURST incidents. For organizations in regulated industries (healthcare, financial services, government), these controls are increasingly non-negotiable for procurement approval.

## Customer Productivity Impact

Implementing these controls correctly requires coordinating changes across the cluster resource and every node pool — a multi-file, multi-block change that is easy to get partially right and hard to verify completely. Gomboc identifies all missing configurations across the entire cluster topology in one pass and generates a complete, validated fix. Security teams get comprehensive coverage — not just the nodes that happened to be in the last manual review. Platform teams reduce the operational burden of maintaining per-service credentials, as Workload Identity provides fine-grained, code-driven identity management that scales naturally with the number of services.
