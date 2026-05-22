# Remediation Request

**Category:** Security

## Finding

Cloud SQL instance `projects/acme-prod-infra/instances/orders-mysql-prod` does not require SSL connections and has authorized network `0.0.0.0/0` (open to the entire internet). 

## Required Action

Required actions:
1. Require SSL for all connections to `projects/acme-prod-infra/instances/orders-mysql-prod`
2. Restrict authorized networks to `10.128.0.0/20` and `10.129.0.0/20`
