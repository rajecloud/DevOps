
# Creating a VPC network in Host project to work as a Shared VPC

resource "google_compute_network" "svpc_network" {
    name                            = var.network_name
    project                         = var.host_project_id
    auto_create_subnetworks         = var.auto_create_subnetworks
    routing_mode                    = var.routing_mode
    delete_default_routes_on_create = var.delete_default_routes_on_create
}


