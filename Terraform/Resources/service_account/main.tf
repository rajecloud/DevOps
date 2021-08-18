
# Creating Service Account to access resources in GCP 

resource "google_service_account" "service_account" {
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_project_iam_member" "sa-iam1" {
  project = var.project_id
  role    = var.iam_role
  member  = "serviceAccount:${google_service_account.service_account.email}"
}



# # SA account IAM access

# resource "google_service_account_iam_member" "sa-iam" {
#   service_account_id = google_service_account.service_account.name
#   role               = "roles/${var.iam_roles}"
#   member             = "user:${var.user_email}"
# }






 