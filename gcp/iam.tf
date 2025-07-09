# Allow Cloud Run services to use Cloud SQL
resource "google_project_iam_member" "cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${var.cloud_run_service_account}"
}

# Allow access to GCS
resource "google_project_iam_member" "storage_access" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${var.cloud_run_service_account}"
}

# Allow access to Pub/Sub
resource "google_project_iam_member" "pubsub_access" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${var.cloud_run_service_account}"
}
