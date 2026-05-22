variable "region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "subnet_id" {
  description = "Private subnet ID the workload instances run in"
  type        = string
  default     = "subnet-0aa11bb22cc33dd44"
}

variable "security_group_id" {
  description = "Security group ID attached to the instances"
  type        = string
  default     = "sg-0ff99ee88dd77cc66"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "acme-prod-ops"
}

variable "ami_amazon_linux" {
  description = "Amazon Linux 2023 AMI for us-east-1"
  type        = string
  default     = "ami-0abcdef1234567890"
}
