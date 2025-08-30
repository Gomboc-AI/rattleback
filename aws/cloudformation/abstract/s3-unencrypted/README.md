# S3 Unencrypted

This shows the three states of S3 buckets.  One is unencrypted.  One is encrypted using Customer Managed Keys (CMK).  And one is encrypted using Provider Managed Keys (PMK).

As long as encryption is provided one is not better then the other, so there are two expectations.  If the CMK is known then the unencrypted bucket should be encrypted using it (example `expected-cmk`).  Otherwise it should be encrypted using PMK (example `expected-pmk`).  In either case the currently encrypted buckets shouldn't be touched.

You should only test against one of the two expectations.

## Unguessable info

The expectation assumes the following:

1. CMK: `arn:aws:kms:us-east-1:111122223333:alias/my-s3-bucket-key`
