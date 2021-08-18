output "ig_name" {
    value = google_compute_instance_group.ig.id
}

output "ig_link" {
    value = google_compute_instance_group.ig.self_link
}