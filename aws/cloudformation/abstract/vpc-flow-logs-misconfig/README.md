# VPC Flow Logs Misconfiguration

Here a flow log set to the wrong bucket.  It should be fixed.

## Unguessable info

The expectation assumes the following:

- VPC Flow Log LogDestination: `!Sub "arn:aws:s3:::gomboc-security-flowlogs-480437182633/${VPC}/"`
