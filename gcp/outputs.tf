output "vpc_id" {
  value = google_compute_network.vpc_network.id
}

output "private_subnet" {
  value = google_compute_subnetwork.private_subnet.name
}

output "cloudsql_instance_connection_name" {
  value = google_sql_database_instance.postgres_instance.connection_name
}
output "cloud_run_urls" {
  value = {
    api                  = google_cloud_run_service.api.status[0].url
    frontend             = google_cloud_run_service.frontend.status[0].url
    media_worker         = google_cloud_run_service.media_worker.status[0].url
    transcription_worker = google_cloud_run_service.transcription_worker.status[0].url
    ai_worker            = google_cloud_run_service.ai_worker.status[0].url
    image_worker         = google_cloud_run_service.image_worker.status[0].url
    trim_worker          = google_cloud_run_service.trim_worker.status[0].url
  }
}
output "gcs_bucket_name" {
  value = google_storage_bucket.media_files.name
}
output "job_queue_topic" {
  value = google_pubsub_topic.job_queue.name
}
output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.frontend_http.ip_address
}
