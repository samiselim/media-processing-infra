resource "google_cloud_run_service" "api" {
  name     = "api-service"
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"      = "1"
        "autoscaling.knative.dev/maxScale"      = "10"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.postgres_instance.connection_name
      }
    }

    spec {
      service_account_name = var.cloud_run_service_account

      containers {
        image = var.api_image
        #command = ["sh", "-c", "while true; do nc -lk -p 8080 -e echo Hello; done"]
        ports {
          container_port = var.api_port
        }

        env {
          name  = "DB_HOST"
          value = "127.0.0.1"
        }

        env {
          name  = "DB_NAME"
          value = google_sql_database.main_db.name
        }

        env {
          name  = "DB_USER"
          value = var.db_username
        }

        env {
          name = "DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.db_password.secret_id
              key  = "latest"
            }
          }
        }

        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Keep other services unchanged below...


resource "google_cloud_run_service" "frontend" {
  name     = "frontend-service"
  location = var.region

  template {
    spec {
      containers {
        image = var.frontend_image
        #command = ["sh", "-c", "while true; do nc -lk -p 8080 -e echo Hello; done"]
        ports {
          container_port = var.frontend_port
        }
        resources {
          limits = {
            memory = "512Mi"
            cpu    = "1"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "1"
        "autoscaling.knative.dev/maxScale" = "10"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "media_worker" {
  name     = "media-worker"
  location = var.region

   template {
    spec {
      containers {
        image = "python:3.9-slim"
        command = ["python3", "-m", "http.server", "8080"]
        ports {
          container_port = 8080
        }
        resources {
          limits = {
            memory = "256Mi"
            cpu    = "0.5"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "transcription_worker" {
  name     = "transcription-worker"
  location = var.region

    template {
    spec {
      containers {
        image = "python:3.9-slim"
        command = ["python3", "-m", "http.server", "8080"]
        ports {
          container_port = 8080
        }
        resources {
          limits = {
            memory = "256Mi"
            cpu    = "0.5"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
resource "google_cloud_run_service" "ai_worker" {
  name     = "ai-worker"
  location = var.region

  template {
    spec {
      containers {
        image = "python:3.9-slim"
        command = ["python3", "-m", "http.server", "8080"]
        ports {
          container_port = 8080
        }
        resources {
          limits = {
            memory = "256Mi"
            cpu    = "0.5"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


resource "google_cloud_run_service" "image_worker" {
  name     = "image-worker"
  location = var.region

  template {
    spec {
      containers {
        image = "python:3.9-slim"
        command = ["python3", "-m", "http.server", "8080"]
        ports {
          container_port = 8080
        }
        resources {
          limits = {
            memory = "256Mi"
            cpu    = "0.5"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_cloud_run_service" "trim_worker" {
  name     = "trim-worker"
  location = var.region

   template {
    spec {
      containers {
        image = "python:3.9-slim"
        command = ["python3", "-m", "http.server", "8080"]
        ports {
          container_port = 8080
        }
        resources {
          limits = {
            memory = "256Mi"
            cpu    = "0.5"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# IAM Member for public access
resource "google_cloud_run_service_iam_member" "public_access" {
  for_each = {
    api                  = google_cloud_run_service.api.name
    frontend             = google_cloud_run_service.frontend.name
    media_worker         = google_cloud_run_service.media_worker.name
    transcription_worker = google_cloud_run_service.transcription_worker.name
    ai_worker            = google_cloud_run_service.ai_worker.name
    image_worker         = google_cloud_run_service.image_worker.name
    trim_worker          = google_cloud_run_service.trim_worker.name
  }

  service  = each.value
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
