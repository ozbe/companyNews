provider "google" {
  credentials = file("sa-key.json")
  project = var.project_name
  region = var.gcp_region
}