# arn:aws:ec2:us-east-1:123456789012:vpc/vpc-0abc123def456789a
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "acme-prod-vpc"
    Environment = "production"
    Team        = "platform"
    CostCenter  = "plat-3001"
  }
}

# arn:aws:ec2:us-east-1:123456789012:internet-gateway/igw-0c9b8a7d6e5f43210
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "acme-prod-igw"
    Environment = "production"
    Team        = "platform"
  }
}

# arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0a1b2c3d4e5f6a7b8 (us-east-1a)
# arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0a1b2c3d4e5f6a7b9 (us-east-1b)
# arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0a1b2c3d4e5f6a7ba (us-east-1c)
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "acme-prod-public-${var.azs[count.index]}"
    Environment = "production"
    Team        = "platform"
    Tier        = "public"
  }
}

# arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0aa11bb22cc33dd44 (us-east-1a)
# arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0aa11bb22cc33dd45 (us-east-1b)
# arn:aws:ec2:us-east-1:123456789012:subnet/subnet-0aa11bb22cc33dd46 (us-east-1c)
resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name        = "acme-prod-private-${var.azs[count.index]}"
    Environment = "production"
    Team        = "platform"
    Tier        = "private"
  }
}

# arn:aws:ec2:us-east-1:123456789012:elastic-ip/eipalloc-0aa11a1a1a1a1a1a1 (us-east-1a)
# arn:aws:ec2:us-east-1:123456789012:elastic-ip/eipalloc-0bb22b2b2b2b2b2b2 (us-east-1b)
# arn:aws:ec2:us-east-1:123456789012:elastic-ip/eipalloc-0cc33c3c3c3c3c3c3 (us-east-1c)
resource "aws_eip" "nat" {
  count  = length(var.azs)
  domain = "vpc"

  tags = {
    Name        = "acme-prod-nat-eip-${var.azs[count.index]}"
    Environment = "production"
    Team        = "platform"
  }
}

# arn:aws:ec2:us-east-1:123456789012:natgateway/nat-01a2b3c4d5e6f7890 (us-east-1a)
# arn:aws:ec2:us-east-1:123456789012:natgateway/nat-11a2b3c4d5e6f7891 (us-east-1b)
# arn:aws:ec2:us-east-1:123456789012:natgateway/nat-21a2b3c4d5e6f7892 (us-east-1c)
resource "aws_nat_gateway" "main" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "acme-prod-nat-${var.azs[count.index]}"
    Environment = "production"
    Team        = "platform"
    CostCenter  = "plat-3001"
  }

  depends_on = [aws_internet_gateway.main]
}

# arn:aws:ec2:us-east-1:123456789012:route-table/rtb-0aaaa111public0
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "acme-prod-public-rtb"
    Environment = "production"
    Team        = "platform"
    Tier        = "public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# arn:aws:ec2:us-east-1:123456789012:route-table/rtb-0bbbb222privaaa1 (us-east-1a)
# arn:aws:ec2:us-east-1:123456789012:route-table/rtb-0bbbb222privbbb2 (us-east-1b)
# arn:aws:ec2:us-east-1:123456789012:route-table/rtb-0bbbb222privccc3 (us-east-1c)
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name        = "acme-prod-private-rtb-${var.azs[count.index]}"
    Environment = "production"
    Team        = "platform"
    Tier        = "private"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# arn:aws:s3:::acme-prod-flowlogs-123456789012
resource "aws_s3_bucket" "flow_logs" {
  bucket = "acme-prod-flowlogs-123456789012"

  tags = {
    Name        = "acme-prod-flowlogs"
    Environment = "production"
    Team        = "platform"
    Purpose     = "vpc-flow-logs"
  }
}

resource "aws_s3_bucket_versioning" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "flow_logs" {
  bucket                  = aws_s3_bucket.flow_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# arn:aws:ec2:us-east-1:123456789012:vpc-flow-log/fl-0123456789abcdef0
resource "aws_flow_log" "main" {
  vpc_id               = aws_vpc.main.id
  log_destination      = aws_s3_bucket.flow_logs.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"

  tags = {
    Name        = "acme-prod-vpc-flow-logs"
    Environment = "production"
    Team        = "platform"
  }
}
