
# Creating an Instance group 

resource "google_compute_instance_group" "ig" {
  name        = var.ig_name
  description = var.description
  project     = var.project_id
  network     = var.network_id
  instances = [var.instances_id]

  named_port {
    name = var.protocol
    port = "22"
  }

  zone = var.zone
}