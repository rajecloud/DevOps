
resource "google_compute_global_address" "subnet_pip_alloc" {
    name          = var.ip_name
    address_type  = var.add_type
    purpose       = var.purpose
    prefix_length = var.prefix_length
    project       = var.project_id
    network       = var.network_id
}

resource "google_service_networking_connection" "snet_connection" {
  provider                = "google-beta"
  network                 = var.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.subnet_pip_alloc.name]
}