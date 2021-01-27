output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "zone" {
  value = var.zone
}

output "env" {
  value = var.env
}

output "gke_name" {
  value = module.gke.cluster_name
  description = "GKE cluster name"
}

output "company_news_cdn_bucket" {
  value = module.company_news.cdn_bucket_name
}

output "company_news_cdn_ip" {
  value = module.company_news.cdn_ip
}