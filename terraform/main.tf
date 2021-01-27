module "network" {
  source = "./modules/network"
  region = var.region
  env = terraform.workspace
  project_name = data.google_project.project.name

  depends_on = [
    google_project_service.services,
  ]
}

module "gke" {
  source = "./modules/gke"
  project_id = var.project_id
  env = terraform.workspace
  zone = var.zone

  primary_node_count = var.gke_primary_node_count
  primary_machine_type = var.gke_primary_machine_type

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
  env          = terraform.workspace
 
  depends_on = [
    google_project_service.services,
  ]
}