locals {
  services = [
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}

resource "google_project_service" "services" {
  count = length(local.services)
  service = element(local.services, count.index)
  disable_on_destroy = false
}