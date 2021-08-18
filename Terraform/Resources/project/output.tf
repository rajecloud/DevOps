output "project_id" {
    value       = google_project.project.id
    description = "Id of the newly created Project for other resources use case"
}

output "project_name" {
    value       = google_project.project.name
    description = "Id of the newly created Project for other resources use case"
}

output "service_project_id" {
    value       = google_compute_shared_vpc_service_project.service_project.id
    description = "Id of the associated service project for other resources use case."
}