# VPC: arn:aws:ec2:us-west-2:123456789012:vpc/vpc-0abc123456789def0
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "prod-vpc"
    Environment = "production"
    Team        = "platform-infra"
  }
}

# Subnet: arn:aws:ec2:us-west-2:123456789012:subnet/subnet-0fed987654321abc0
resource "aws_subnet" "web" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name        = "prod-web-subnet"
    Environment = "production"
  }
}

# Subnet: arn:aws:ec2:us-west-2:123456789012:subnet/subnet-0aaa111222333bbb0
resource "aws_subnet" "monitoring" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name        = "prod-monitoring-subnet"
    Environment = "production"
  }
}

# Security group: arn:aws:ec2:us-west-2:123456789012:security-group/sg-0abc123def456
module "web_sg" {
  source = "./modules/security-group"

  name        = "web-server-sg"
  description = "Security group for web server instances"
  vpc_id      = aws_vpc.main.id

  ingress_rules = [
    {
      description = "SSH access"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "HTTPS access"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Application port"
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
  ]

  tags = {
    Name        = "web-server-sg"
    Environment = "production"
    Team        = "platform-infra"
  }
}

# Security group: arn:aws:ec2:us-west-2:123456789012:security-group/sg-0mon456ghi789jkl
module "monitoring_sg" {
  source = "./modules/security-group"

  name        = "monitoring-sg"
  description = "Security group for monitoring stack"
  vpc_id      = aws_vpc.main.id

  ingress_rules = [
    {
      description = "Prometheus scrape from internal"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
    },
    {
      description = "Grafana UI from VPN"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16"]
    },
  ]

  tags = {
    Name        = "monitoring-sg"
    Environment = "production"
    Team        = "observability"
  }
}

# EC2 instance: arn:aws:ec2:us-west-2:123456789012:instance/i-0fedcba987654
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.web.id
  vpc_security_group_ids = [module.web_sg.id]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = "prod-web-server"
    Environment = "production"
    Team        = "platform-infra"
  }
}

# EC2 instance: arn:aws:ec2:us-west-2:123456789012:instance/i-0mon123abc456def
resource "aws_instance" "monitoring" {
  ami                    = var.ami_id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.monitoring.id
  vpc_security_group_ids = [module.monitoring_sg.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name        = "prod-monitoring"
    Environment = "production"
    Team        = "observability"
  }
}

# Security group: arn:aws:ec2:us-west-2:123456789012:security-group/sg-0xyz789abc012def
resource "aws_security_group" "db" {
  name        = "database-sg"
  description = "Security group for database instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "MySQL from app tier"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "database-sg"
    Environment = "production"
  }
}
