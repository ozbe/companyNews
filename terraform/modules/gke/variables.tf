variable project_id {
  type = string
}

variable env {
  type = string
}

variable zone {
  type = string
}

variable primary_node_count {
  type = number
  description = "Number of primary nodes "
}

variable primary_machine_type {
  type = string
}

variable network {
  type = string
}

variable subnetwork {
  type = string
}

variable pods_secondary_range_name {
  type = string
}

variable services_secondary_range_name {
  type = string
}