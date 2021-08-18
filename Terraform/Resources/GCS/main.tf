# Creating a Google Cloud Storage bucket

resource "google_storage_bucket" "bucket" {
    name          = var.bucket_name
    location      = var.location
    project       = var.project_id
    storage_class = var.storage_class
    force_destroy = var.force_destroy
    retention_policy {
        retention_period = var.retention_policy
    } 
    versioning {
        enabled = var.version_enabled
    }
    lifecycle_rule {
        action {
            type = var.lifecycle_type
        }
        condition {
            age = var.age
        }
    }
}