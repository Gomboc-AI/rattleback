# IaC Scanning Proof of Concept

This is a combination of several scenarios:

1. VPC is missing flowlogs
  1. They should be sent to a pre-created S3 bucket
2. The default VPC SG is not locked down
  1. It is not possible to delete the default, but a good alternative is to set it to a safe port on a safe host.
3. The EC2 EBS is not encrypted
4. The S3 bucket is not encrypted
5. The DynamoDB table is not encrypted

## Unguessable Information

The expected results assumes the following:

1. The VPC flowlog destination is gomboc specific bucket with the VPC id as the prefix:
  1. `!Sub "arn:aws:s3:::gomboc-security-flowlogs-480437182633/${VPC}/"`
2. The VPC SG safe port is "65535"
3. The VPC SG safe CIDR is "1.1.1.1/32"
