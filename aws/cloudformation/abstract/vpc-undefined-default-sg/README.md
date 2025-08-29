# VPC with undefined Default SG

A VPC without a defined default SG has an insecure enabled.  There is no way to prevent that, so the best solution is to make the default SG useless.

## Unguessable Information

The expected results assumes the following:

1. The VPC SG safe port is "65535"
2. The VPC SG safe CIDR is "1.1.1.1/32"
