
output "ilb_link" {
    value = google_compute_forwarding_rule.ilb.self_link
    description = "URL for the created Internal Load Balancer"
}