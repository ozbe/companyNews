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
  value = module.gke.cluster_name
  description = "GKE cluster name"
}

output "company_news_public_bucket_name" {
  value = module.company_news.public_bucket_name
}