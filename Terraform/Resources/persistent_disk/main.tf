resource "google_compute_disk" "disk" {
  name        = var.disk_names
  project     = var.project_id
  size        = var.disk_sizes
  type        = var.disk_type
  zone        = var.disk_zones 
  labels = {
        environment     = var.disk_label1_value
      }
}

resource "google_compute_attached_disk" "attach-disk" {
  disk     = google_compute_disk.disk.id
  instance = var.instance_id
}