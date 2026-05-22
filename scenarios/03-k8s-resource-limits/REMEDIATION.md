# Remediation Request

**Category:** Reliability

## Finding

Deployment `frontend-web` in namespace `production` has no resource requests or limits set on any of its containers. Without resource constraints, pods can consume unbounded CPU and memory, leading to noisy-neighbor issues and potential node instability.

## Required Action

Set resource requests and limits on the `frontend-web` deployment:

- **Memory requests:** 256Mi
- **Memory limits:** 512Mi
- **CPU requests:** 100m
- **CPU limits:** 500m
