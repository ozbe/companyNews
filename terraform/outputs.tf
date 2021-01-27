output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "zones" {
  value = var.zones
}

output "env" {
  value = var.env
}

output "gke_name" {
  value = google_container_cluster.gke.name
  description = "GKE cluster name"
}