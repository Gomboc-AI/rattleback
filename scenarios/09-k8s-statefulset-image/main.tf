# Namespace: caching
resource "kubernetes_namespace_v1" "caching" {
  metadata {
    name = var.namespace

    labels = {
      app         = var.app_name
      environment = "production"
    }
  }
}

# Service: namespaces/caching/services/redis-cluster-headless
resource "kubernetes_service_v1" "redis_headless" {
  metadata {
    name      = "${var.app_name}-headless"
    namespace = kubernetes_namespace_v1.caching.metadata[0].name

    labels = {
      app = var.app_name
    }
  }

  spec {
    selector = {
      app = var.app_name
    }

    cluster_ip = "None"

    port {
      name        = "redis"
      port        = 6379
      target_port = 6379
    }

    port {
      name        = "gossip"
      port        = 16379
      target_port = 16379
    }
  }
}

# StatefulSet: namespaces/caching/statefulsets/redis-cluster
resource "kubernetes_stateful_set_v1" "redis_cluster" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.caching.metadata[0].name

    labels = {
      app = var.app_name
    }
  }

  spec {
    service_name = kubernetes_service_v1.redis_headless.metadata[0].name
    replicas     = var.replicas

    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          name  = "redis"
          image = var.image

          command = [
            "redis-server",
            "--cluster-enabled", "yes",
            "--cluster-config-file", "/data/nodes.conf",
            "--cluster-node-timeout", "5000",
            "--appendonly", "yes",
            "--appendfilename", "appendonly.aof",
            "--maxmemory", "2gb",
            "--maxmemory-policy", "volatile-lru",
          ]

          port {
            container_port = 6379
            name           = "redis"
          }

          port {
            container_port = 16379
            name           = "gossip"
          }

          volume_mount {
            name       = "redis-data"
            mount_path = "/data"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1"
              memory = "3Gi"
            }
          }

          liveness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 15
            period_seconds        = 10
            timeout_seconds       = 5
          }

          readiness_probe {
            exec {
              command = ["redis-cli", "ping"]
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "redis-data"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "standard"

        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }
  }
}

# StatefulSet: namespaces/caching/statefulsets/memcached-cluster
resource "kubernetes_stateful_set_v1" "memcached" {
  metadata {
    name      = "memcached-cluster"
    namespace = kubernetes_namespace_v1.caching.metadata[0].name
    labels = {
      app = "memcached-cluster"
    }
  }

  spec {
    service_name = "memcached-headless"
    replicas     = 3

    selector {
      match_labels = {
        app = "memcached-cluster"
      }
    }

    template {
      metadata {
        labels = {
          app = "memcached-cluster"
        }
      }

      spec {
        container {
          name  = "memcached"
          image = "memcached:1.6.23"

          port {
            container_port = 11211
            name           = "memcached"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "memcached-data"
      }
      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "standard"
        resources {
          requests = {
            storage = "5Gi"
          }
        }
      }
    }
  }
}
