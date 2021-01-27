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

variable "zones" {
  type = list(string)
  default = [
    "australia-southeast1-b",
  ]
}

variable "env" {
  type        = string
  description = "Environment"
}

variable gke_num_nodes {
  type = number
  default = 1
}