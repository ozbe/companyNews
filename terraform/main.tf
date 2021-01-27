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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

data "google_client_config" "default" {
}

data "google_project" "project" {
}

module "network" {
  source = "./modules/network"
  region = var.region
  env = var.env
  project_name = data.google_project.project.name

  depends_on = [
    google_project_service.services,
  ]
}

module "gke" {
  source = "./modules/gke"
  project_id = var.project_id
  env = var.env
  zones = var.zones

  gke_num_nodes = var.gke_num_nodes

  network = module.network.network_name
  subnetwork = module.network.subnetwork_name
  pods_secondary_range_name = module.network.pods_secondary_range_name
  services_secondary_range_name = module.network.services_secondary_range_name

  depends_on = [
    google_project_service.services,
  ]
}

module "company_news" {
  source       = "./modules/company_news"
  project_name = data.google_project.project.name
  env          = var.env
 
  depends_on = [
    google_project_service.services,
  ]
}