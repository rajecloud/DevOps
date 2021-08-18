# Creating Firewall Rules for the network configuration

resource "google_compute_firewall" "firewall_rule" {
    name            = var.firewall_name
    network         = var.network_id
    project         = var.project_id
    allow {
        protocol = var.protocol
        ports    = var.ports
    }
    allow {
        protocol = "icmp"
    }
    allow {
        protocol = "udp"
        ports = var.udp_ports
    }
    allow {
        protocol = "http"
        ports = var.http_ports
    }
    allow {
        protocol = "https"
        ports = var.https_ports
    }	
    direction       = var.direction
    source_tags     = var.source_tags
    target_tags     = var.target_tags
    source_ranges   = var.source_ranges
    enable_logging  = var.logging_enable
}