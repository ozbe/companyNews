provider "google" {
  project     = var.project_id
  region      = var.region
}

# Mostly to get project name
data "google_project" "project" {
}