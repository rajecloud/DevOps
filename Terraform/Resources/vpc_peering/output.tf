
output "first_network_peering_id" {
    value       = google_compute_network_peering.first_network_peering.id
    description = "Id of the peered first network for further usecase"
}

output "second_network_peering_id" {
    value       = google_compute_network_peering.second_network_peering.id
    description = "Id of the peered second network for further usecase"
}

