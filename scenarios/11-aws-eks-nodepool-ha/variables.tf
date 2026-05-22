variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "prod-cluster"
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
  default     = "vpc-0abc123def456789a"
}

variable "subnet_ids" {
  description = "Map of availability zone to subnet ID"
  type        = map(string)
  default = {
    "us-east-1a" = "subnet-0aaa111bbb222ccc3"
    "us-east-1b" = "subnet-0ddd444eee555fff6"
  }
}

variable "system_node_min_size" {
  description = "Minimum number of nodes in the system node group"
  type        = number
  default     = 2
}

variable "system_node_max_size" {
  description = "Maximum number of nodes in the system node group"
  type        = number
  default     = 5
}

variable "system_node_desired_size" {
  description = "Desired number of nodes in the system node group"
  type        = number
  default     = 3
}
