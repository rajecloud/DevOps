
output "backend_id" {
    value = google_compute_region_backend_service.ilb_back.id
}


output "backend_link" {
    value = google_compute_region_backend_service.ilb_back.self_link
}