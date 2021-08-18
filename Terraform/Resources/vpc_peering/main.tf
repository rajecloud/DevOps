
# Creating a VPC peering inbetween two networks (First and Second) in Host project for resources communication

resource "google_compute_network_peering" "first_network_peering" {
    name                    = var.first_peer_network_name
    network                 = var.first_network_id
    peer_network            = var.second_network_id
    export_custom_routes    = var.export_custom_routes
    import_custom_routes    = var.import_custom_routes

}

resource "google_compute_network_peering" "second_network_peering" {
    name                    = var.second_peer_network_name
    network                 = var.second_network_id
    peer_network            = var.first_network_id

}

# Route configuration of both the network peering

resource "google_compute_network_peering_routes_config" "peering" {
    peering                 = google_compute_network_peering.first_network_peering.name
    network                 = var.network_id
    import_custom_routes    = var.import_custom_routes
    export_custom_routes    = var.export_custom_routes
    depends_on              = ["google_compute_network_peering.first_network_peering"]
}