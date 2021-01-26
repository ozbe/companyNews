variable "project_name" {
  type = string
}

# Chosen because in Australia and supports GPUS.
# TODO - check pricing and other resources supported
# https://cloud.google.com/compute/docs/regions-zones/
variable "gcp_region" {
  type    = string
  default = "australia-southeast1-b"
}

variable "env" {
  type        = string
  description = "Environment"
}