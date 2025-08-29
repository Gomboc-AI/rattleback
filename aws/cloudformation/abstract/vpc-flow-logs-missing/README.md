# VPC Flow Logs Missing

Here there are no flow logs.  A flow log block should be added

## Unguessable info

The expectation assumes the following:

1. The VPC Flow Log Object Name: `FlowLogBucket`
1. The VPC Flow Log LogDestination: `!Sub "arn:aws:s3:::gomboc-security-flowlogs-480437182633/${VPC}/"`
