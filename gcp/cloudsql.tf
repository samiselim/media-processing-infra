resource "google_sql_database_instance" "postgres_instance" {
  name             = "media-postgres-instance"
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro" # You can upgrade to "db-custom-1-3840" or more based on load
    ip_configuration {
      ipv4_enabled = true

      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0" # Narrow this to secure range for production
      }
    }
    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = false
}

resource "google_sql_user" "postgres_user" {
  name     = var.db_username
  instance = google_sql_database_instance.postgres_instance.name
  password = var.db_password
}

resource "google_sql_database" "main_db" {
  name     = "media_db"
  instance = google_sql_database_instance.postgres_instance.name
}
