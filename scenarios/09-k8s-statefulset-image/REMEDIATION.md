# Remediation Request

**Category:** Security

## Finding

StatefulSet `redis-cluster` in namespace `caching` runs image `redis:6.2.7` which has known vulnerabilities including CVE-2023-41056 (heap-based buffer overflow in the Redis networking code) and CVE-2023-41053 (Redis SORT_RO command can be used to bypass ACL restrictions). These vulnerabilities can lead to remote code execution and unauthorized data access.

## Required Action

Update the container image for StatefulSet `redis-cluster` in namespace `caching` from `redis:6.2.7` to patched version `redis:6.2.16`.
