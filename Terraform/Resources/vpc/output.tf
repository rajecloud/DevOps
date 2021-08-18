
output "network_id" {
    value = google_compute_network.svpc_network.id
    description = "Id of the newly created network for further usecase"
}

output "network_link" {
    value = google_compute_network.svpc_network.self_link
    description = "URI link of the newly created network for further usecase"
}


