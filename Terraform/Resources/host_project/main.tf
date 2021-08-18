# Associating the created project as Host project to work as a Shared VPC

resource "google_compute_shared_vpc_host_project" "host_project" {
   project           = var.project_id
}