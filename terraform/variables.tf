variable "project_id" {
  type = string
}

# Region and zone because in Australia and supports GPUS.
# TODO - check pricing and other resources supported
# https://cloud.google.com/compute/docs/regions-zones/
variable "region" {
  type    = string
  default = "australia-southeast1"
}

# This should be `list(string)`, but I've kept is a `string` for simplicity
variable "zone" {
  type    = string
  default = "australia-southeast1-b"
}

variable "gke_primary_node_count" {
  type    = number
  default = 1
}

# This machine type is the bare minimum. Chosen mostly for testing reasons
# After evaluating the performance of pods, this machine_type may need adjusted
variable "gke_primary_machine_type" {
  type    = string
  default = "n1-standard-1"
}

# Change this if app persistence layer supports more than one instance
variable "company_news_web_server_replica_count" {
  type    = number
  default = 1
}

variable "services" {
  type        = list(string)
  description = "Project services to manage by terraform"
  default = [
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}