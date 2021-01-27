#
# Network
# 
# GCP network with one subnet configured for GKE
#

resource "google_compute_network" "network" {
  name                    = "${var.project_name}-network"
  auto_create_subnetworks = "false"
}

locals {
  subnet_name_prefix = "${var.project_name}-subnet"
}

# CIDR ranges provided by Google documentation. 
# Would want to revaluate ranges after further discussion of what 
# will be on the network (and GKE) and having a 
# discussion with a network engineer
resource "google_compute_subnetwork" "subnet" {
  name          = "${local.subnet_name_prefix}-env"
  region        = var.region
  network       = google_compute_network.network.name
  ip_cidr_range = "10.0.0.0/17"

  secondary_ip_range = [
    {
      range_name    = "${local.subnet_name_prefix}-range-pod-${var.env}"
      ip_cidr_range = "192.168.0.0/18"
    },
    {
      range_name    = "${local.subnet_name_prefix}-range-svc-${var.env}"
      ip_cidr_range = "192.168.64.0/18"
    },
  ]
}

