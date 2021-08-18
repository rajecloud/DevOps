
# Creating an Instance group and Instance Template

resource "google_compute_instance_template" "template" {
  name_prefix                 = var.instance_name
  machine_type                = var.machine_type
  region                      = var.region
  network_interface {
    network                 = var.network
    subnetwork              = var.subnetwork
  }
  disk {
    auto_delete             = var.auto_delete  
    boot                    = var.disk_condition
    source_image            = var.image
  }
  lifecycle {
    create_before_destroy   = true
  }
  scheduling {
    on_host_maintenance     = var.on_host_maintenance_policy
  }
  description                 = var.description
  labels                      = {
    environment             = var.label_value
  } 
  project                     = var.project_id
  tags                        = var.tags    
}

# Creating a Resource Group Manager and Assigning the creating Instances

resource "google_compute_instance_group_manager" "gce_mig" {
  name                          = var.mig_name
  base_instance_name            = var.base_name
  zone                          = var.zone
  project                       = var.project_id
  target_size                   = var.targets
  version {
    instance_template  = google_compute_instance_template.template.id
  }
}


