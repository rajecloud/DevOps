
# Creating a Sub network in above created VPC to work as a Shared VPC subnet resource

resource "google_compute_subnetwork" "svpc_subnetwork" {
    name            = var.subnetwork_name
    ip_cidr_range   = var.ip_cidr_range
    network         = var.network_name
    region          = var.region
    project         = var.host_project_id
}
