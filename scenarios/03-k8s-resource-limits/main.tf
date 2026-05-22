# Namespace: production
resource "kubernetes_namespace_v1" "app" {
  metadata {
    name = var.namespace

    labels = {
      environment = "production"
      managed-by  = "terraform"
    }
  }
}

# Deployment: namespaces/production/deployments/frontend-web
resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.app.metadata[0].name

    labels = {
      app     = var.app_name
      version = "v1"
    }
  }

  spec {
    replicas = 3

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "1"
        max_unavailable = "0"
      }
    }

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app     = var.app_name
          version = "v1"
        }

        annotations = {
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "9090"
        }
      }

      spec {
        container {
          name  = "web"
          image = var.image

          port {
            container_port = 80
            protocol       = "TCP"
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 80
            }

            initial_delay_seconds = 10
            period_seconds        = 15
          }

          readiness_probe {
            http_get {
              path = "/ready"
              port = 80
            }

            initial_delay_seconds = 5
            period_seconds        = 10
          }
        }

        container {
          name  = "envoy-sidecar"
          image = var.sidecar_image

          port {
            container_port = 9901
            protocol       = "TCP"
          }

          port {
            container_port = 10000
            protocol       = "TCP"
          }

          liveness_probe {
            http_get {
              path = "/ready"
              port = 9901
            }

            initial_delay_seconds = 15
            period_seconds        = 20
          }
        }
      }
    }
  }
}

# Deployment: namespaces/production/deployments/backend-api
resource "kubernetes_deployment_v1" "backend" {
  metadata {
    name      = "backend-api"
    namespace = kubernetes_namespace_v1.app.metadata[0].name
    labels = {
      app     = "backend-api"
      version = "v2"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "backend-api"
      }
    }

    template {
      metadata {
        labels = {
          app     = "backend-api"
          version = "v2"
        }
      }

      spec {
        container {
          name  = "api"
          image = "acme/backend-api:v2.1.0"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
          }
        }
      }
    }
  }
}
