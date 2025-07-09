


resource "google_pubsub_topic" "jobs" {
  name = "media-jobs"
}
resource "google_sql_database_instance" "postgres" {
  name             = "media-db"
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "default" {
  name     = var.db_username
  instance = google_sql_database_instance.postgres.name
  password = var.db_password
}
