data "aws_caller_identity" "management" {
  provider = aws.management
}

data "aws_caller_identity" "member_prod" {
  provider = aws.member_prod
}

data "aws_caller_identity" "member_data" {
  provider = aws.member_data
}

# arn:aws:s3:::acme-mgmt-audit-logs-111111111111
resource "aws_s3_bucket" "mgmt_audit" {
  provider = aws.management
  bucket   = "acme-mgmt-audit-logs-111111111111"

  tags = {
    Name        = "acme-mgmt-audit-logs"
    Environment = "production"
    Team        = "security"
    Purpose     = "cloudtrail-audit"
    CostCenter  = "sec-1001"
  }
}

resource "aws_s3_bucket_versioning" "mgmt_audit" {
  provider = aws.management
  bucket   = aws_s3_bucket.mgmt_audit.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mgmt_audit" {
  provider = aws.management
  bucket   = aws_s3_bucket.mgmt_audit.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "mgmt_audit" {
  provider                = aws.management
  bucket                  = aws_s3_bucket.mgmt_audit.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "mgmt_audit" {
  provider = aws.management
  bucket   = aws_s3_bucket.mgmt_audit.id
  policy   = data.aws_iam_policy_document.mgmt_audit.json
}

data "aws_iam_policy_document" "mgmt_audit" {
  statement {
    sid     = "AWSCloudTrailAclCheck"
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [aws_s3_bucket.mgmt_audit.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:111111111111:trail/acme-mgmt-audit"]
    }
  }

  statement {
    sid     = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = ["${aws_s3_bucket.mgmt_audit.arn}/AWSLogs/111111111111/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:111111111111:trail/acme-mgmt-audit"]
    }
  }
}

# arn:aws:cloudtrail:us-east-1:111111111111:trail/acme-mgmt-audit
resource "aws_cloudtrail" "mgmt_audit" {
  provider = aws.management
  name     = "acme-mgmt-audit"

  s3_bucket_name                = aws_s3_bucket.mgmt_audit.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  tags = {
    Name        = "acme-mgmt-audit"
    Environment = "production"
    Team        = "security"
    CostCenter  = "sec-1001"
  }

  depends_on = [aws_s3_bucket_policy.mgmt_audit]
}

# arn:aws:s3:::acme-prod-audit-logs-222222222222
resource "aws_s3_bucket" "prod_audit" {
  provider = aws.member_prod
  bucket   = "acme-prod-audit-logs-222222222222"

  tags = {
    Name        = "acme-prod-audit-logs"
    Environment = "production"
    Team        = "security"
    Purpose     = "cloudtrail-audit"
    CostCenter  = "sec-1001"
  }
}

resource "aws_s3_bucket_versioning" "prod_audit" {
  provider = aws.member_prod
  bucket   = aws_s3_bucket.prod_audit.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "prod_audit" {
  provider = aws.member_prod
  bucket   = aws_s3_bucket.prod_audit.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "prod_audit" {
  provider                = aws.member_prod
  bucket                  = aws_s3_bucket.prod_audit.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "prod_audit" {
  provider = aws.member_prod
  bucket   = aws_s3_bucket.prod_audit.id
  policy   = data.aws_iam_policy_document.prod_audit.json
}

data "aws_iam_policy_document" "prod_audit" {
  statement {
    sid     = "AWSCloudTrailAclCheck"
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [aws_s3_bucket.prod_audit.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:222222222222:trail/acme-prod-audit"]
    }
  }

  statement {
    sid     = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = ["${aws_s3_bucket.prod_audit.arn}/AWSLogs/222222222222/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:222222222222:trail/acme-prod-audit"]
    }
  }
}

# arn:aws:cloudtrail:us-east-1:222222222222:trail/acme-prod-audit
resource "aws_cloudtrail" "prod_audit" {
  provider = aws.member_prod
  name     = "acme-prod-audit"

  s3_bucket_name                = aws_s3_bucket.prod_audit.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  tags = {
    Name        = "acme-prod-audit"
    Environment = "production"
    Team        = "security"
    CostCenter  = "sec-1001"
  }

  depends_on = [aws_s3_bucket_policy.prod_audit]
}

# arn:aws:s3:::acme-data-audit-logs-333333333333
resource "aws_s3_bucket" "data_audit" {
  provider = aws.member_data
  bucket   = "acme-data-audit-logs-333333333333"

  tags = {
    Name        = "acme-data-audit-logs"
    Environment = "production"
    Team        = "security"
    Purpose     = "cloudtrail-audit"
    CostCenter  = "sec-1001"
  }
}

resource "aws_s3_bucket_versioning" "data_audit" {
  provider = aws.member_data
  bucket   = aws_s3_bucket.data_audit.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "data_audit" {
  provider = aws.member_data
  bucket   = aws_s3_bucket.data_audit.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "data_audit" {
  provider                = aws.member_data
  bucket                  = aws_s3_bucket.data_audit.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "data_audit" {
  provider = aws.member_data
  bucket   = aws_s3_bucket.data_audit.id
  policy   = data.aws_iam_policy_document.data_audit.json
}

data "aws_iam_policy_document" "data_audit" {
  statement {
    sid     = "AWSCloudTrailAclCheck"
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [aws_s3_bucket.data_audit.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:333333333333:trail/acme-data-audit"]
    }
  }

  statement {
    sid     = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = ["${aws_s3_bucket.data_audit.arn}/AWSLogs/333333333333/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:333333333333:trail/acme-data-audit"]
    }
  }
}

# arn:aws:cloudtrail:us-east-1:333333333333:trail/acme-data-audit
resource "aws_cloudtrail" "data_audit" {
  provider = aws.member_data
  name     = "acme-data-audit"

  s3_bucket_name                = aws_s3_bucket.data_audit.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  tags = {
    Name        = "acme-data-audit"
    Environment = "production"
    Team        = "security"
    CostCenter  = "sec-1001"
  }

  depends_on = [aws_s3_bucket_policy.data_audit]
}

# arn:aws:s3:::acme-pci-trail-logs-222222222222
resource "aws_s3_bucket" "pci_trail" {
  provider = aws.member_prod
  bucket   = "acme-pci-trail-logs-222222222222"

  tags = {
    Name        = "acme-pci-trail-logs"
    Environment = "production"
    Team        = "compliance"
    Purpose     = "pci-data-events"
    Compliance  = "pci-dss-v4"
    CostCenter  = "comp-2050"
  }
}

resource "aws_s3_bucket_versioning" "pci_trail" {
  provider = aws.member_prod
  bucket   = aws_s3_bucket.pci_trail.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pci_trail" {
  provider = aws.member_prod
  bucket   = aws_s3_bucket.pci_trail.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pci_trail" {
  provider                = aws.member_prod
  bucket                  = aws_s3_bucket.pci_trail.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "pci_trail" {
  provider = aws.member_prod
  bucket   = aws_s3_bucket.pci_trail.id
  policy   = data.aws_iam_policy_document.pci_trail.json
}

data "aws_iam_policy_document" "pci_trail" {
  statement {
    sid     = "AWSCloudTrailAclCheck"
    actions = ["s3:GetBucketAcl"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [aws_s3_bucket.pci_trail.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:222222222222:trail/acme-pci-data-events"]
    }
  }

  statement {
    sid     = "AWSCloudTrailWrite"
    actions = ["s3:PutObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = ["${aws_s3_bucket.pci_trail.arn}/AWSLogs/222222222222/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = ["arn:aws:cloudtrail:${var.region}:222222222222:trail/acme-pci-data-events"]
    }
  }
}

# arn:aws:cloudtrail:us-east-1:222222222222:trail/acme-pci-data-events
resource "aws_cloudtrail" "pci_data_events" {
  provider = aws.member_prod
  name     = "acme-pci-data-events"

  s3_bucket_name                = aws_s3_bucket.pci_trail.id
  include_global_service_events = false
  is_multi_region_trail         = false
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = false

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::acme-pci-regulated-data/"]
    }
  }

  tags = {
    Name        = "acme-pci-data-events"
    Environment = "production"
    Team        = "compliance"
    Compliance  = "pci-dss-v4"
    CostCenter  = "comp-2050"
  }

  depends_on = [aws_s3_bucket_policy.pci_trail]
}
