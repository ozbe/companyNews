provider "google" {
  credentials = file("sa-key.json")
  project = "ozbe-companynews"
  # Chosen because in Australia and supports GPUS.
  # TODO - check pricing and other resources supported
  # https://cloud.google.com/compute/docs/regions-zones/
  region = "australia-southeast1-b"
}