resource "google_secret_manager_secret" "this" {
  project   = var.project_id
  secret_id = var.secret_id
  labels    = var.labels

  lifecycle {
    precondition {
      condition     = var.replication_type != "user_managed" || length(var.replication_locations) > 0
      error_message = "replication_locations must not be empty when replication_type is \"user_managed\"."
    }
  }

  replication {
    dynamic "auto" {
      for_each = var.replication_type == "automatic" ? [1] : []
      content {}
    }

    dynamic "user_managed" {
      for_each = var.replication_type == "user_managed" ? [1] : []
      content {
        dynamic "replicas" {
          for_each = var.replication_locations
          content {
            location = replicas.value
          }
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "this" {
  secret      = google_secret_manager_secret.this.id
  secret_data = var.secret_data

  lifecycle {
    create_before_destroy = true
  }
}
