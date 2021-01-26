provider "google" {
  credentials = file("sa-key.json")
  project     = var.project_name
  region      = var.gcp_region
}

module "static_assets" {
  source       = "./modules/static-assets"
  project_name = var.project_name
  env          = var.env
  depends_on = [
    google_project_service.compute,
  ]
}