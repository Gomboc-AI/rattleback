variable "namespace" {
  description = "Kubernetes namespace for the deployment"
  type        = string
  default     = "production"
}

variable "app_name" {
  description = "Name of the application deployment"
  type        = string
  default     = "frontend-web"
}

variable "image" {
  description = "Container image for the main application"
  type        = string
  default     = "nginx:1.25"
}

variable "sidecar_image" {
  description = "Container image for the sidecar proxy"
  type        = string
  default     = "envoyproxy/envoy:v1.28"
}
