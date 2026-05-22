variable "namespace" {
  description = "Kubernetes namespace for the Redis cluster"
  type        = string
  default     = "caching"
}

variable "app_name" {
  description = "Name of the Redis cluster application"
  type        = string
  default     = "redis-cluster"
}

variable "image" {
  description = "Container image for Redis"
  type        = string
  default     = "redis:6.2.7"
}

variable "replicas" {
  description = "Number of Redis replicas"
  type        = number
  default     = 3
}
