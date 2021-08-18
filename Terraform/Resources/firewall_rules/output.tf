
output "firewall_id" {
    value = google_compute_firewall.firewall_rule.id
}

output "firewall_link" {
    value = google_compute_firewall.firewall_rule.self_link
}