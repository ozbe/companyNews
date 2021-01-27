output "cdn_bucket_name" {
  value = google_storage_bucket.cdn.name
}

output "cdn_ip" {
  value = google_compute_global_address.cdn.address
}