variable "region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "organization_id" {
  description = "AWS Organizations ID (o-xxxxxxxxxx)"
  type        = string
  default     = "o-abc1234xyz"
}
