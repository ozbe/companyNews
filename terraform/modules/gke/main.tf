#
# GKE
# 
# Zonal VPC-Native GKE cluster with one node in the primary node pool 
#

locals {
  # Location set to a zone to make the cluster zonal and less expensive for testing. 
  # Location should be made regional to support the HA usecase.
  location = var.zone
  cluster_name = "${var.project_id}-gke-${var.env}"
}

resource "google_container_cluster" "gke" {
  name     = local.cluster_name
  location = local.location

  # Recommended to use a separately managed node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  # VPC-native GCP recommended practice and default for CLI and Console
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
}

resource "google_container_node_pool" "gke_primary" {
  name       = "${google_container_cluster.gke.name}-node-pool"
  location   = local.location
  cluster    = google_container_cluster.gke.name
  node_count = var.primary_node_count

  node_config {
    # Scopes for loggin and monitoring
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    # It is recommended practice to use a custom service account
    # to manage scope and permissions via IAM Roles
    # service_account = "TODO"

    labels = {
      env = var.env
    }

    machine_type = var.primary_machine_type
    tags         = [local.cluster_name]
    metadata = {
      # All that remains of some other security enhancements
      # https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata
      disable-legacy-endpoints = "true"
    }
  }
}