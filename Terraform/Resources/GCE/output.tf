output "instance_id" {
    value = google_compute_instance.gce.id
}

output "instance_link" {
    value = google_compute_instance.gce.self_link
}