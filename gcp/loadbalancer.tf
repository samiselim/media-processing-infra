resource "google_compute_region_network_endpoint_group" "frontend_neg" {
  name                  = "frontend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = google_cloud_run_service.frontend.name
  }
}



resource "google_compute_backend_service" "frontend_backend" {
  name                  = "frontend-backend"
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  port_name             = "http"
  enable_cdn            = true

  backend {
    group = google_compute_region_network_endpoint_group.frontend_neg.id
  }

#   health_checks = [google_compute_health_check.default.self_link]
}


resource "google_compute_url_map" "frontend_map" {
  name            = "frontend-url-map"
  default_service = google_compute_backend_service.frontend_backend.id
}

resource "google_compute_target_http_proxy" "frontend_proxy" {
  name    = "frontend-proxy"
  url_map = google_compute_url_map.frontend_map.id
}

resource "google_compute_global_forwarding_rule" "frontend_http" {
  name        = "frontend-http-rule"
  target      = google_compute_target_http_proxy.frontend_proxy.id
  port_range  = "80"
  ip_protocol = "TCP"
}


resource "google_compute_health_check" "default" {
  name = "basic-check"

  http_health_check {
    port = 80
  }
}
