# parent_folder_id            = ""
# team_folder_name            = ""
# realm_folder_name           = ""
# project_name                = ""
# sp_id                       = ""
# gcp_billing_acount          = ""
# service_project_condition   = ""
# sa_account_id               = "github-sa"
# iam_roles                   = "roles/iam.serviceAccountUser","roles/storage.admin", "roles/compute.admin"
project_id                  = "us-gcp-ame-con-728-sbx-1"
vpc_name                    = "test-vpc1"
ip_range_east               = "10.0.0.0/24"
ip_range_central            = "10.1.0.0/24"
first_region                = "us-east4"
second_region               = "us-central1"
first_zone                  = "us-east4-a"
second_zone                 = "us-east4-b"
third_zone                  = "us-central1-a"
primary_instance_name       = "primary-appliance"
secondary_instance_name     = "secondary-appliance"
ondemand_instance_name      = "on-demand-infrastructure"
mac_type                    = "n1-standard-1"
image                       = "ubuntu-os-cloud/ubuntu-1804-lts"
firewall_ports              = ["80"]
disk_size                   = 10
source_tags1                = "github-east-instances"
target_tags1                = "github-east-instances"
source_tags2                = "github-central-instances"
target_tags2                = "github-central-instances"
fw_ip_ranges                = "0.0.0.0/0"
environment                 = "prod"
primary_instance_tags       = "github-primary-instance"
secondary_instance_tags     = "github-secondary-instance"
ondemand_instance_tags      = "github-ondemand-instance"
gcs_name                    = "demo_github_bucket"
gcs_retention_policy        = "147"
gcs_lc_type                 = "Delete"
gcs_lc_age                  = "2"
ilb_name                    = "github-ilb"
#lb_ports                    = ["80"]
ilb_hc_ports                = ["80"]
ig_protocol                 = "tcp"
ig_ports                    = 22
pd_size                     = 10
pd_type                     = "pd-standard"