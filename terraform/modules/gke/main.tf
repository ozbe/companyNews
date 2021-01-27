locals {
  location = var.zones[0]
  cluster_name = "${var.project_id}-gke-${var.env}"
}

resource "google_container_cluster" "gke" {
  name     = local.cluster_name
  location = local.location

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }
}

resource "google_container_node_pool" "gke_primary" {
  name       = "${google_container_cluster.gke.name}-node-pool"
  location   = local.location
  cluster    = google_container_cluster.gke.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.env
    }

    machine_type = "n1-standard-1"
    tags         = [local.cluster_name]
    metadata = {
      # https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata
      disable-legacy-endpoints = "true"
    }
  }
}