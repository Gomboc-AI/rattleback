# arn:aws:iam::123456789012:role/acme-workload-ec2-role
resource "aws_iam_role" "workload" {
  name = "acme-workload-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}

# arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore -> arn:aws:iam::123456789012:role/acme-workload-ec2-role
resource "aws_iam_role_policy_attachment" "workload_ssm" {
  role       = aws_iam_role.workload.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# arn:aws:iam::123456789012:instance-profile/acme-workload-ec2-profile
resource "aws_iam_instance_profile" "workload" {
  name = "acme-workload-ec2-profile"
  role = aws_iam_role.workload.name
}

# arn:aws:ec2:us-east-1:123456789012:instance/i-0aa11bb22cc33dd44
resource "aws_instance" "dev_sandbox" {
  ami                    = var.ami_amazon_linux
  instance_type          = "m5.2xlarge"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.workload.name
  monitoring             = true
  ebs_optimized          = true

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 200
    encrypted   = true
    tags = {
      Name        = "acme-dev-sandbox-root"
      Environment = "development"
      Team        = "data-engineering"
    }
  }

  tags = {
    Name        = "acme-dev-sandbox"
    Environment = "development"
    Team        = "data-engineering"
    CostCenter  = "de-1042"
    Workload    = "developer-sandbox"
  }
}

# arn:aws:ec2:us-east-1:123456789012:instance/i-0bb22cc33dd44ee55
resource "aws_instance" "web_primary" {
  ami                    = var.ami_amazon_linux
  instance_type          = "m5.xlarge"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.workload.name
  monitoring             = true
  ebs_optimized          = true

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
    encrypted   = true
    tags = {
      Name        = "acme-web-primary-root"
      Environment = "production"
      Team        = "backend"
    }
  }

  tags = {
    Name        = "acme-web-primary"
    Environment = "production"
    Team        = "backend"
    CostCenter  = "be-2048"
    Workload    = "web-server"
  }
}

# arn:aws:ec2:us-east-1:123456789012:instance/i-0cc33dd44ee55ff66
resource "aws_instance" "weekly_etl" {
  ami                    = var.ami_amazon_linux
  instance_type          = "c5.4xlarge"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.workload.name
  monitoring             = true
  ebs_optimized          = true

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 100
    encrypted   = true
    tags = {
      Name        = "acme-weekly-etl-root"
      Environment = "production"
      Team        = "data-engineering"
    }
  }

  tags = {
    Name        = "acme-weekly-etl"
    Environment = "production"
    Team        = "data-engineering"
    CostCenter  = "de-1042"
    Workload    = "weekly-batch"
    Schedule    = "saturday-02-06-utc"
  }
}

# arn:aws:ec2:us-east-1:123456789012:instance/i-0dd44ee55ff66aa77
resource "aws_instance" "monitoring_agent" {
  ami                    = var.ami_amazon_linux
  instance_type          = "t3.medium"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.workload.name
  monitoring             = true
  ebs_optimized          = false

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
    tags = {
      Name        = "acme-monitoring-agent-root"
      Environment = "production"
      Team        = "platform"
    }
  }

  tags = {
    Name        = "acme-monitoring-agent"
    Environment = "production"
    Team        = "platform"
    CostCenter  = "plat-3001"
    Workload    = "observability"
  }
}
