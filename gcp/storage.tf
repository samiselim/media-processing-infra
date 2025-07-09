resource "google_storage_bucket" "media_files" {
  name          = "${var.project_id}-media-files"
  location      = var.region
  force_destroy = true

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "gcs_access" {
  bucket = google_storage_bucket.media_files.name
  role   = "roles/storage.objectViewer"
  member = "allUsers" # or serviceAccount if restricted access is needed
}
