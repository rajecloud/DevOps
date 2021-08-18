
# Creating Internal Load Balancer for secondary instance setup to balance the internal traffic

resource "google_compute_forwarding_rule" "ilb" {
    name                    = var.lb_name
    project                 = var.service_project_id
    region                  = var.region
    all_ports               = var.all_ports
    load_balancing_scheme   = var.lb_scheme
    network                 = var.network_id
    subnetwork              = var.subnetwork_id
    backend_service         = google_compute_region_backend_service.ilb_back.self_link
    ip_protocol             = var.protocol
    #ports                   = var.ports
}


# Creating a Backend for LB

resource "google_compute_region_backend_service" "ilb_back" {
    name            = "${var.lb_name}-backend"
    region          = var.region
    project         = var.service_project_id
    dynamic "backend" {
        for_each = var.backends
        content {
            group       = lookup(backend.value, "group", null)
        }
    }
    
    health_checks   = [google_compute_health_check.health_check.id]
}

resource "google_compute_health_check" "health_check" {
    #count               = var.http_hc_condition ? 1 : 0
    name                = var.health_check_name
    project             = var.service_project_id
    check_interval_sec  = var.interval_check
    timeout_sec         = var.timeout
    http_health_check {
        port            = "80"
    }
}