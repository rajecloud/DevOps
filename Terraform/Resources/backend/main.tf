
# Creating a Backend for LB

resource "google_compute_region_backend_service" "ilb_back" {
    name            = var.backend_name
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