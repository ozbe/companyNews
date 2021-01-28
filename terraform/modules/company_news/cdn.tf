#
# CDN
# 
# Host assets in GCS and serve them via Load balancer, fronted by Cloud CDN
#

resource "google_storage_bucket" "cdn" {
  name = "${var.project_name}-cdn-${var.env}"
  # Not a best practice, but helpful for a coding challenge
  force_destroy = true
}

resource "google_storage_default_object_access_control" "cdn_read" {
  bucket = google_storage_bucket.cdn.name
  role = "READER"
  entity = "allUsers"
}

resource "google_compute_backend_bucket" "cdn" {
  name = "static-assets-backend"
  bucket_name = google_storage_bucket.cdn.name
  enable_cdn = true
}

resource "google_compute_url_map" "cdn" {
  name = "static-assets-url-map"
  default_service = google_compute_backend_bucket.cdn.self_link
}

# This would ideally be google_compute_target_https_proxy
resource "google_compute_target_http_proxy" "cdn" {
  name = "static-assets-target-proxy"
  url_map = google_compute_url_map.cdn.self_link
}

resource "google_compute_global_address" "cdn" {
  name = "static-assets-ip"
}

resource "google_compute_global_forwarding_rule" "cdn" {
  name = "static-assets-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.cdn.address
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_http_proxy.cdn.self_link
}