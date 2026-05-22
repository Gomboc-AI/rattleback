# Remediation Request

**Category:** Reliability / Cost

## Finding

EKS cluster arn:aws:eks:us-east-1:123456789012:cluster/prod-cluster needs improved availability. Currently operating in us-east-1a and us-east-1b only. Add capacity in us-east-1c.

The cluster uses both Cluster Autoscaler (managing system node group eks-system-pool) and Karpenter (managing general workloads). The new capacity must maximize coverage of Savings Plan arn:aws:savingsplans::123456789012:savingsplan/sp-abc123 which covers c5.2xlarge and m5.2xlarge instances.

## Required Action

Extend the cluster networking and node scheduling to include us-east-1c so nodes can be placed across all three availability zones. Prefer instance types covered by the existing Savings Plan when provisioning in the new zone.
