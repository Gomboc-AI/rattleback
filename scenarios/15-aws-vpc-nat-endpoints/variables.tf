variable "region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the production VPC"
  type        = string
  default     = "10.42.0.0/16"
}

variable "azs" {
  description = "Availability zones used for subnet placement"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.42.0.0/24", "10.42.1.0/24", "10.42.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.42.16.0/20", "10.42.32.0/20", "10.42.48.0/20"]
}
