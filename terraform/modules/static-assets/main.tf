
resource "google_storage_bucket" "static_assets" {
  name = "${var.project_name}-static_assets-${var.env}"
  force_destroy = true
}

resource "google_storage_default_object_access_control" "static_assets_read" {
  bucket = google_storage_bucket.static_assets.name
  role = "READER"
  entity = "allUsers"
}

resource "google_compute_backend_bucket" "static_assets" {
  name = "static-assets-backend"
  bucket_name = google_storage_bucket.static_assets.name
  enable_cdn = true
}

resource "google_compute_url_map" "static_assets" {
  name = "static-assets-url-map"
  default_service = google_compute_backend_bucket.static_assets.self_link
}

resource "google_compute_target_http_proxy" "static_assets" {
  name = "static-assets-target-proxy"
  url_map = google_compute_url_map.static_assets.self_link
}

resource "google_compute_global_address" "static_assets" {
  name = "static-assets-ip"
}

resource "google_compute_global_forwarding_rule" "static_assets" {
  name = "static-assets-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.static_assets.address
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_http_proxy.static_assets.self_link
}