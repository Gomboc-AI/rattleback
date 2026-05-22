# ──────────────────────────────────────────────────────────────────────────────
# Production orders database — serves the orders-api microservice
# ──────────────────────────────────────────────────────────────────────────────

# Subnet group: acme-orders-db-subnet-group
resource "aws_db_subnet_group" "orders" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.db_name}-subnet-group"
    Environment = "production"
    Team        = "backend"
  }
}

# Security group: arn:aws:ec2:us-west-2:123456789012:security-group/sg-0db987654fedcba
resource "aws_security_group" "orders_db" {
  name        = "${var.db_name}-sg"
  description = "Security group for orders database"
  vpc_id      = var.vpc_id

  ingress {
    description = "MySQL from internal networks"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.db_name}-sg"
    Environment = "production"
    Team        = "backend"
  }
}

# RDS instance: arn:aws:rds:us-west-2:123456789012:db:acme-orders-db (PRODUCTION — handles 50k orders/day)
resource "aws_db_instance" "orders" {
  identifier     = var.db_name
  engine         = "mysql"
  engine_version = "8.0"

  instance_class    = var.db_instance_class
  allocated_storage = 100
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "orders"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.orders.name
  vpc_security_group_ids = [aws_security_group.orders_db.id]

  skip_final_snapshot = true

  tags = {
    Name        = var.db_name
    Environment = "production"
    Team        = "backend"
    CostCenter  = "be-2048"
  }
  multi_az                = true
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
}

# RDS instance: arn:aws:rds:us-west-2:123456789012:db:acme-orders-staging (STAGING — test data only)
resource "aws_db_instance" "staging" {
  identifier     = "acme-orders-staging"
  engine         = "mysql"
  engine_version = "8.0"

  instance_class    = "db.t3.medium"
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "orders_staging"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.orders.name
  vpc_security_group_ids = [aws_security_group.orders_db.id]

  multi_az                = true
  backup_retention_period = 7
  backup_window           = "04:00-05:00"
  skip_final_snapshot     = true

  tags = {
    Name        = "acme-orders-staging"
    Environment = "staging"
    Team        = "backend"
  }
}
