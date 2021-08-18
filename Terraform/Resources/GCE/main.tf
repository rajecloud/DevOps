############### Google Compute Engine Instance ###############

resource "google_compute_instance" "gce" {
  name                      = var.instance_name
  machine_type              = var.machine_type
  zone                      = var.zone
  network_interface {
    network                 = var.network
    subnetwork              = var.subnetwork
    access_config {
      // Ephemeral IP
	# nat_ip = var.ephemeral_ip
    }
  }
  boot_disk {
    auto_delete             = var.auto_delete  
   initialize_params {
      size                  = var.disk_size
      type                  = var.disk_type
      image                 = var.image
    }
  }
  scheduling {
    on_host_maintenance     = var.on_host_maintenance_policy
  }
  can_ip_forward            = var.can_ip_forward
  deletion_protection       = var.deletion_protection
  description               = var.description
  labels                    = {
        environment         = var.label_value
  } 
  project                   = var.project_id
  tags                      = var.tags  
  service_account {
    #email                   = var.service_account
    scopes                  = ["cloud-platform"]
  }    
}   
