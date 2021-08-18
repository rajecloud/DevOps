
# VPC

resource "google_compute_network" "network" {
    name                            = "form-test-vpc1"
    project                         = var.project_id
    auto_create_subnetworks         = false
    routing_mode                    = "GLOBAL"
    delete_default_routes_on_create = false
}

# Subnet

resource "google_compute_subnetwork" "subnetwork" {
    name            = "form-test-subnet1"
    ip_cidr_range   = "10.1.0.0/24"
    network         = google_compute_network.network.name
    region          = var.region
    project         = var.project_id
    depends_on      = ["google_compute_network.network"]
}

#Service Connection

resource "google_compute_global_address" "subnet_pip_alloc" {
    name          = "form-test-scon1"
    address_type  = "INTERNAL"
    purpose       = "VPC_PEERING"
    prefix_length = 16
    project       = "us-gcp-ame-con-728-sbx-1"
    network       = google_compute_network.network.id
    depends_on    = ["google_compute_subnetwork.subnetwork"]
}

resource "google_service_networking_connection" "snet_connection" {
  provider                = "google-beta"
  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.subnet_pip_alloc.name]
}

# Create a Cloud SQL Database

resource "google_sql_database" "db" {
    name              = var.db_name
    instance          = google_sql_database_instance.db_instance.name
    project           = var.project_id
    depends_on        = ["google_sql_database_instance.db_instance"]
}

# Create a Cloud SQL Database Instance

resource "google_sql_database_instance" "db_instance" {
    name                    = var.db_instance_name
    region                  = var.region
    project                 = var.project_id
    database_version        = var.db_version
    settings {
        tier                = "db-f1-micro"
        availability_type   = "ZONAL" 
        disk_size           = var.db_disk_size
        ip_configuration {
            ipv4_enabled    = false
            private_network = "projects/${var.project_id}/global/networks/form-test-vpc"
        }
    }
    depends_on              = ["google_service_networking_connection.snet_connection"]
}

# Create a DB Instance user

# resource "google_sql_user" "users" {
#     count    = var.db_user_creation ? 1 : 0
#     name     = var.db_user_name
#     instance = google_sql_database_instance.db_instance.name
#     password = var.db_password
# }
