
resource "google_storage_bucket" "company_news_public" {
  name = "${var.project_name}-company_news_public-${var.env}"
  # Not a best practice, but helpful for a coding challenge
  force_destroy = true
}

resource "google_storage_default_object_access_control" "company_news_public_read" {
  bucket = google_storage_bucket.company_news_public.name
  role = "READER"
  entity = "allUsers"
}

resource "google_compute_backend_bucket" "company_news_public" {
  name = "static-assets-backend"
  bucket_name = google_storage_bucket.company_news_public.name
  enable_cdn = true
}

resource "google_compute_url_map" "company_news_public" {
  name = "static-assets-url-map"
  default_service = google_compute_backend_bucket.company_news_public.self_link
}

resource "google_compute_target_http_proxy" "company_news_public" {
  name = "static-assets-target-proxy"
  url_map = google_compute_url_map.company_news_public.self_link
}

resource "google_compute_global_address" "company_news_public" {
  name = "static-assets-ip"
}

resource "google_compute_global_forwarding_rule" "company_news_public" {
  name = "static-assets-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address = google_compute_global_address.company_news_public.address
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_http_proxy.company_news_public.self_link
}