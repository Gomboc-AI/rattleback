resource "google_container_cluster" "non_compliant_cluster" {
  name     = var.cluster_name
  location = var.location

  # Enable RBAC
  enable_legacy_abac = true

  # The non-compliant setting: allow anonymous access by enabling the legacy ABAC
  # This allows unauthenticated users (system:anonymous) to have access,
  # which violates the CIS recommendation to avoid bindings to system:anonymous.

  # Minimal required settings for a valid cluster
  initial_node_count = 1

  node_config {
    machine_type = var.machine_type
  }

  rbac_binding_config {
    enable_insecure_binding_system_unauthenticated = false
  }
}

resource "google_container_cluster" "non_compliant_cluster_explicit" {
  name     = var.cluster_name
  location = var.location

  # Enable RBAC
  enable_legacy_abac = true

  # The non-compliant setting: allow anonymous access by enabling the legacy ABAC
  # This allows unauthenticated users (system:anonymous) to have access,
  # which violates the CIS recommendation to avoid bindings to system:anonymous.

  # Minimal required settings for a valid cluster
  initial_node_count = 1

  node_config {
    machine_type = var.machine_type
  }

  rbac_binding_config {
    enable_insecure_binding_system_unauthenticated = false
  }
}

resource "google_container_cluster" "compliant_cluster" {
  name     = var.cluster_name
  location = var.location

  # Enable RBAC
  enable_legacy_abac = true

  # Minimal required settings for a valid cluster
  initial_node_count = 1

  node_config {
    machine_type = var.machine_type
  }

  rbac_binding_config {
    enable_insecure_binding_system_unauthenticated = false
  }
}
