output "subnet_id" {
    value = google_compute_subnetwork.svpc_subnetwork.id
    description = "Id of the newly created subnets for further usecase"
}

output "subnet_link" {
    value = google_compute_subnetwork.svpc_subnetwork.self_link
    description = "URI link of the newly created network for further usecase"
}
