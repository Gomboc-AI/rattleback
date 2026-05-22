# Scenario: Kubernetes Resource Limits

- ID: 03
- Provider: Kubernetes
- Category: Reliability
- Language: Terraform

## Why This Matters

Kubernetes uses resource requests and limits to make scheduling decisions and enforce fairness. Without them, a container has no ceiling on how much CPU or memory it can consume. A memory leak, a traffic spike, or a runaway batch job in one pod can silently exhaust a node's resources, causing unrelated workloads to be evicted or throttled. In a production namespace serving real users, this is a reliability risk that is invisible until it becomes an outage — and the cause is difficult to diagnose in the moment.

## Business Case

Resource limits are a foundational requirement in the CIS Kubernetes Benchmark and NSA/CISA Kubernetes Hardening Guidance. For organizations offering multi-tenant platforms or running mixed workloads on shared clusters, they are the enforcement boundary between services. From a financial perspective, limits also enable accurate capacity planning: without them, it is impossible to predict cluster utilization or set meaningful SLAs. For enterprise SaaS companies, a noisy-neighbor incident that degrades multiple customer tenants simultaneously is a contractual and reputational liability.

## Customer Productivity Impact

Platform engineers and application developers typically operate under different incentives: developers want to ship quickly and rarely think about resource constraints until something breaks. Gomboc closes that gap by detecting missing resource configurations in code review and inserting the correct values automatically. Operations teams benefit from predictable cluster behavior, fewer 3am pages, and faster root-cause analysis when incidents do occur. Security and compliance teams get evidence that the CIS Benchmark control is enforced across all deployments, not just the ones that were manually reviewed.
