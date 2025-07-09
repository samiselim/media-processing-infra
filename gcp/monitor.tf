resource "google_monitoring_alert_policy" "pubsub_backlog_alert" {
  display_name = "Pub/Sub Job Queue Backlog Alert"

  combiner = "OR"
  conditions {
    display_name = "Backlog > 100 messages"
    condition_threshold {
      filter = <<EOT
metric.type="pubsub.googleapis.com/subscription/num_undelivered_messages"
resource.type="pubsub_subscription"
resource.label."subscription_id"="${google_pubsub_subscription.worker_subscription.name}"
EOT

      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 100
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_MEAN"
        group_by_fields      = []
      }
    }
  }

  notification_channels = [] # Optional: link to Slack/email later

  alert_strategy {
    auto_close = "3600s"
  }

  documentation {
    content   = "The media job queue has exceeded 100 unacknowledged messages."
    mime_type = "text/markdown"
  }

  enabled = true
}

