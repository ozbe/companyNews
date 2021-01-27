provider "google" {
  credentials = file("sa-key.json")
  project     = var.project_id
  region      = var.region
}

provider "kubernetes" {
  load_config_file       = false
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

data "google_client_config" "default" {
}

data "google_project" "project" {
}

module "static_assets" {
  count = 0
  source       = "./modules/static-assets"
  project_name = data.google_project.project.name
  env          = var.env
 
  depends_on = [
    google_project_service.services,
  ]
}