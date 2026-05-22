# Remediation Request

**Category:** Security

## Finding

GKE cluster `projects/acme-prod-infra/locations/us-central1/clusters/main-cluster` lacks Workload Identity and Shielded Nodes.

## Required Action

Enable Workload Identity on `projects/acme-prod-infra/locations/us-central1/clusters/main-cluster` with the GKE Metadata Server. Enable Shielded Nodes with Secure Boot and Integrity Monitoring.
