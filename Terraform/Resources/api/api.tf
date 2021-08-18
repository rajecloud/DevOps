# Enabling the required API Services for created Project use case

resource "google_project_services" "api_services" {
  project              = var.project_id
  services             = var.project_services
  disable_on_destroy   = var.disable_on_destroy
}