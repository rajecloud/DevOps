# Creating a new Project for respective Application Environment

resource "google_project" "project" {
  name                = var.project_name
  project_id          = var.project_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
}


# Associating the created project with host project to work as a service project

resource "google_compute_shared_vpc_service_project" "service_project" {
  count = var.service_project ? 1 : 0
  host_project    = var.host_project_id
  service_project = google_project.Project.id
}
