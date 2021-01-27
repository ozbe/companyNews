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
  type = string
  default = "australia-southeast1-b"
}

variable "env" {
  type        = string
  description = "Environment"
}

variable gke_num_nodes {
  type = number
  default = 1
}

variable services {
  type = list(string)
  description = "Project services to manage by terraform"
  default = [
    "compute.googleapis.com",
    "container.googleapis.com"
  ]
}