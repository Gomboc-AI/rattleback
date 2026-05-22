# Cloud SQL instance: projects/acme-prod-infra/instances/orders-mysql-prod
resource "google_sql_database_instance" "main" {
  name             = var.instance_name
  database_version = "MYSQL_8_0"
  region           = var.region
  project          = var.project_id

  settings {
    tier              = "db-n1-standard-4"
    availability_type = "REGIONAL"
    disk_size         = 100
    disk_type         = "PD_SSD"

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "02:00"
    }

    ip_configuration {
      ipv4_enabled = true
      require_ssl  = false

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.key
          value = authorized_networks.value
        }
      }
    }

    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }
  }

  deletion_protection = true
}

# Cloud SQL instance: projects/acme-prod-infra/instances/orders-mysql-staging
resource "google_sql_database_instance" "staging" {
  name             = "orders-mysql-staging"
  database_version = "MYSQL_8_0"
  region           = var.region
  project          = var.project_id

  settings {
    tier              = "db-n1-standard-2"
    availability_type = "ZONAL"
    disk_size         = 50
    disk_type         = "PD_SSD"

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "04:00"
    }

    ip_configuration {
      ipv4_enabled = true
      require_ssl  = true

      authorized_networks {
        name  = "vpc-primary"
        value = "10.128.0.0/20"
      }

      authorized_networks {
        name  = "vpc-secondary"
        value = "10.129.0.0/20"
      }
    }

    maintenance_window {
      day          = 6
      hour         = 5
      update_track = "stable"
    }
  }

  deletion_protection = true
}

# Database: projects/acme-prod-infra/instances/orders-mysql-prod/databases/orders
resource "google_sql_database" "orders" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
  project  = var.project_id
}

# User: projects/acme-prod-infra/instances/orders-mysql-prod/users/app-service
resource "google_sql_user" "app" {
  name     = "app-service"
  instance = google_sql_database_instance.main.name
  host     = "%"
  password = "change-me-in-secret-manager"
  project  = var.project_id
}

# orders-api deployment: namespaces/orders/deployments/orders-api
resource "kubernetes_namespace_v1" "orders" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment_v1" "orders_api" {
  metadata {
    name      = "orders-api"
    namespace = kubernetes_namespace_v1.orders.metadata[0].name
    labels = {
      app = "orders-api"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "orders-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "orders-api"
        }
      }

      spec {
        container {
          name  = "orders-api"
          image = var.orders_api_image

          port {
            container_port = 8080
          }

          env {
            name  = "DATABASE_HOST"
            value = google_sql_database_instance.main.ip_address[0].ip_address
          }

          env {
            name  = "DATABASE_NAME"
            value = google_sql_database.orders.name
          }

          env {
            name  = "DATABASE_USER"
            value = google_sql_user.app.name
          }

          env {
            name  = "DATABASE_SSL_MODE"
            value = "disabled"
          }
        }
      }
    }
  }
}
