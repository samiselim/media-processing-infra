resource "google_pubsub_topic" "job_queue" {
  name = "media-job-queue"
}
resource "google_pubsub_subscription" "worker_subscription" {
  name  = "media-job-subscription"
  topic = google_pubsub_topic.job_queue.name
}