output network_name {
  value = google_compute_network.network.name
}

output subnetwork_name {
  value = google_compute_subnetwork.subnet.name
}

output pods_secondary_range_name {
  value = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
} 

output services_secondary_range_name {
  value = google_compute_subnetwork.subnet.secondary_ip_range[0].range_name
}