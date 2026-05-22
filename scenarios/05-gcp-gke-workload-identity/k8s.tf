# ──────────────────────────────────────────────────────────────────────────────
# Main cluster workloads
# ──────────────────────────────────────────────────────────────────────────────

resource "kubernetes_namespace_v1" "payments" {
  metadata {
    name = "payments"
  }
}

resource "kubernetes_namespace_v1" "notifications" {
  metadata {
    name = "notifications"
  }
}

resource "kubernetes_namespace_v1" "audit" {
  metadata {
    name = "audit"
  }
}

# Deployment: namespaces/payments/deployments/payments-processor
resource "kubernetes_deployment_v1" "payments_processor" {
  metadata {
    name      = "payments-processor"
    namespace = kubernetes_namespace_v1.payments.metadata[0].name
    labels = {
      app         = "payments-processor"
      environment = "production"
      tier        = "backend"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "payments-processor"
      }
    }

    template {
      metadata {
        labels = {
          app         = "payments-processor"
          environment = "production"
          tier        = "backend"
        }
      }

      spec {
        container {
          name  = "payments-processor"
          image = "nginx:1.25-alpine"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }
      }
    }
  }
}

# Deployment: namespaces/notifications/deployments/notification-service
resource "kubernetes_deployment_v1" "notification_service" {
  metadata {
    name      = "notification-service"
    namespace = kubernetes_namespace_v1.notifications.metadata[0].name
    labels = {
      app         = "notification-service"
      environment = "production"
      tier        = "backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "notification-service"
      }
    }

    template {
      metadata {
        labels = {
          app         = "notification-service"
          environment = "production"
          tier        = "backend"
        }
      }

      spec {
        container {
          name  = "notification-service"
          image = "nginx:1.25-alpine"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "200m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "400m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# Deployment: namespaces/audit/deployments/audit-logger
resource "kubernetes_deployment_v1" "audit_logger" {
  metadata {
    name      = "audit-logger"
    namespace = kubernetes_namespace_v1.audit.metadata[0].name
    labels = {
      app         = "audit-logger"
      environment = "production"
      tier        = "backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "audit-logger"
      }
    }

    template {
      metadata {
        labels = {
          app         = "audit-logger"
          environment = "production"
          tier        = "backend"
        }
      }

      spec {
        container {
          name  = "audit-logger"
          image = "nginx:1.25-alpine"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

# ──────────────────────────────────────────────────────────────────────────────
# Dev cluster workloads
# ──────────────────────────────────────────────────────────────────────────────

resource "kubernetes_namespace_v1" "payments_dev" {
  provider = kubernetes.dev

  metadata {
    name = "payments"
  }
}

resource "kubernetes_namespace_v1" "notifications_dev" {
  provider = kubernetes.dev

  metadata {
    name = "notifications"
  }
}

resource "kubernetes_namespace_v1" "audit_dev" {
  provider = kubernetes.dev

  metadata {
    name = "audit"
  }
}

# Deployment: namespaces/payments/deployments/payments-processor on dev-cluster
resource "kubernetes_deployment_v1" "payments_processor_dev" {
  provider = kubernetes.dev

  metadata {
    name      = "payments-processor"
    namespace = kubernetes_namespace_v1.payments_dev.metadata[0].name
    labels = {
      app         = "payments-processor"
      environment = "development"
      tier        = "backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "payments-processor"
      }
    }

    template {
      metadata {
        labels = {
          app         = "payments-processor"
          environment = "development"
          tier        = "backend"
        }
      }

      spec {
        container {
          name  = "payments-processor"
          image = "nginx:1.25-alpine"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_pod_disruption_budget_v1" "payments_processor_dev" {
  provider = kubernetes.dev

  metadata {
    name      = "payments-processor"
    namespace = kubernetes_namespace_v1.payments_dev.metadata[0].name
  }

  spec {
    min_available = 1
    selector {
      match_labels = {
        app = "payments-processor"
      }
    }
  }
}

# Deployment: namespaces/notifications/deployments/notification-service on dev-cluster
resource "kubernetes_deployment_v1" "notification_service_dev" {
  provider = kubernetes.dev

  metadata {
    name      = "notification-service"
    namespace = kubernetes_namespace_v1.notifications_dev.metadata[0].name
    labels = {
      app         = "notification-service"
      environment = "development"
      tier        = "backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "notification-service"
      }
    }

    template {
      metadata {
        labels = {
          app         = "notification-service"
          environment = "development"
          tier        = "backend"
        }
      }

      spec {
        container {
          name  = "notification-service"
          image = "nginx:1.25-alpine"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_pod_disruption_budget_v1" "notification_service_dev" {
  provider = kubernetes.dev

  metadata {
    name      = "notification-service"
    namespace = kubernetes_namespace_v1.notifications_dev.metadata[0].name
  }

  spec {
    min_available = 1
    selector {
      match_labels = {
        app = "notification-service"
      }
    }
  }
}

# Deployment: namespaces/audit/deployments/audit-logger on dev-cluster
resource "kubernetes_deployment_v1" "audit_logger_dev" {
  provider = kubernetes.dev

  metadata {
    name      = "audit-logger"
    namespace = kubernetes_namespace_v1.audit_dev.metadata[0].name
    labels = {
      app         = "audit-logger"
      environment = "development"
      tier        = "backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "audit-logger"
      }
    }

    template {
      metadata {
        labels = {
          app         = "audit-logger"
          environment = "development"
          tier        = "backend"
        }
      }

      spec {
        container {
          name  = "audit-logger"
          image = "nginx:1.25-alpine"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_pod_disruption_budget_v1" "audit_logger_dev" {
  provider = kubernetes.dev

  metadata {
    name      = "audit-logger"
    namespace = kubernetes_namespace_v1.audit_dev.metadata[0].name
  }

  spec {
    min_available = 1
    selector {
      match_labels = {
        app = "audit-logger"
      }
    }
  }
}
