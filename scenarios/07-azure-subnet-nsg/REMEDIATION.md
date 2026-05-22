# Remediation Request

**Category:** Security

## Finding

Subnet `/subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/virtualNetworks/vnet-prod/subnets/snet-app-tier` has no Network Security Group associated. Traffic to and from this subnet is unrestricted at the network layer, leaving workloads exposed to lateral movement and unauthorized access.

## Required Action

Associate NSG `/subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/networkSecurityGroups/nsg-app-tier-default` to subnet `/subscriptions/aaaa-bbbb/resourceGroups/rg-prod-network/providers/Microsoft.Network/virtualNetworks/vnet-prod/subnets/snet-app-tier`.
