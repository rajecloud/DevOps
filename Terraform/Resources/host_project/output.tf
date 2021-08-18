
output "host_project_id" {
    value       = google_compute_shared_vpc_host_project.host_project.id
    description = "Id of the Host project for other resources use case."
}
