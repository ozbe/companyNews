locals {
  # Location set to a zone to make the cluster zonal and less expensive for testing. 
  # Location should be made regional to support the HA usecase.
  location = var.zone
  cluster_name = "${var.project_id}-gke-${var.env}"
}

resource "google_container_cluster" "gke" {
  name     = local.cluster_name
  location = local.location

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  # VPC-native
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
    # Scopes for loggin and monitoring
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.env
    }

    # This machine type is the bare minimum. Chosen mostly for testing reasons
    # After evaluating the performance of pods, this machine_type may need adjusted
    machine_type = "n1-standard-1"
    tags         = [local.cluster_name]
    metadata = {
      # All that remains of some other security enhancements
      # https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata
      disable-legacy-endpoints = "true"
    }
  }
}