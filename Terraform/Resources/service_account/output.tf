
output "sa_id" {
  value = google_service_account.service_account.id
}

output "sa_email" {
  value = google_service_account.service_account.email
}