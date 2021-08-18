################# Google Cloud Provider ###################

provider "google" {
    version = "3.20.0"
    region  = var.region
}

############### Folders Creation ################

module "team_folder" {
    source              = ""
    folder_name         = var.team_folder_name
    parent_folder       = var.parent_folder_id
}

module "realm_folder" {
    source              = ""
    folder_name         = var.realm_folder_name
    parent_folder       = module.team_folder.folder_id
    depends_on          = ["module.team_folder"]
}

################ Service Project ###################

module "project" {
    source                      = ""
    service_project             = var.service_project_condition
    #for_each                    = { for value in var.realm_folder_values: value.corp => value }
    #project_name                = var.realm_folder_name == "corp" ? each.value.corp || var.realm_folder_name == "prod" ? each.value.prod || var.realm_folder_name == "sys" ? each.value.sys || var.realm_folder_name == "test" ? each.value.test
    project_name                = var.project_name
    project_id                  = var.sp_id
    folder_id                   = module.folder1.name
    billing_account             = var.gcp_billing_account
    auto_create_sub_network     = false
    depends_on                  = ["module.folder2"]
}

################### Service Account #####################

module "sa" {
    source              = ""
    account_id          = var.sa_account_id
    display_name        = "${var.vpc_name}-sa"
    project_id          = var.project_id  #project_id  = module.project.service_project_id
    iam_roles           = [var.iam_roles]
    #depends_on          = ["module.project"]
}

################## VPC #######################

module "vpc" {
    source                                  = ""
    network_name                            = var.vpc_name
    host_project_id                         = var.project_id  #project_id  = module.project.service_project_id
    auto_create_subnetworks                 = false
    routing_mode                            = "GLOBAL"
    delete_default_routes_on_create         = false
    #depends_on                              = ["module.project"]
}

#################### Subnet ######################

module "subnet" {
    source                     = ""
    subnetwork_name            = "${var.vpc_name}-subnets"
    ip_cidr_range              = var.ip_range
    network_name               = var.vpc_name    #network_name  = module.vpc.service_vpc_id
    region                     = var.region
    host_project_id            = var.project_id  #project_id  = module.project.service_project_id
    depends_on                 = ["module.vpc"]
}

################### Firewall Rules #######################

module "firewall_rules"{
    source           = ""
    firewall_name    = "${var.vpc_name}-fwrules"
    network_id       = var.vpc_name     #network_name  = module.vpc.service_vpc_id
    project_id       = var.project_id   #project_id  = module.project.service_project_id
    protocol         = "tcp"
    ports            = var.firewall_ports
    source_tags      = [var.source_tags]
    target_tags      = [var.target_tags]
    source_ranges    = [var.fw_ip_ranges]
    depends_on       = ["module.subnet"]
}

################### Primary Appliance GCE ####################

module "managed-ig" {
    source                      = ""
    instance_name               = var.instance_name
    base_name                   = var.base_name
    machine_type                = var.mac_type
    region                      = var.region
    network                     = var.vpc_name  #network_name  = module.vpc.service_vpc_id
    subnetwork                  = "${var.vpc_name}-subnets"
    auto_delete                 = true  
    disk_condition              = true
    image                       = var.image
    on_host_maintenance_policy  = "MIGRATE"
    description                 = "GitHub GCE Instances Templates"
    label_value                 = var.environment
    project_id                  = var.project_id    #project_id  = module.project.service_project_id
    tags                        = [var.mig_tags]
    zone                        = var.zone
    mig_name                    = "${var.instance_name}-mig"
    targets                     = var.instance_targets
    depends_on                  = ["module.subnet"]
}


#################### GCS Bucket ##########################

module "gcs_bucket" {
    source              = ""
    bucket_name         = var.gcs_name
    location            = "US"
    project_id          = var.project_id    #project_id  = module.project.service_project_id
    storage_class       = "STANDARD"
    force_destroy       = false
    retention_policy    = var.gcs_retention_policy
    lifecycle_type      = var.gcs_lc_type
    age                 = var.gcs_lc_age
    version_enabled     = false
    depends_on          = ["module.managed-ig"]
}

#################### Load Balancer #######################

module "lb" {
    source                  = ""
    lb_name                 = var.ilb_name
    service_project_id      = var.project_id    #project_id  = module.project.service_project_id
    region                  = var.region
    #all_ports               = var.all_ports
    lb_scheme               = "INTERNAL"
    network_id              = var.vpc_name  #network_name  = module.vpc.service_vpc_id
    subnetwork_id           = "${var.vpc_name}-subnets"
    protocol                = "TCP"
    ports                   = [var.lb_ports]
    health_check_name       = "${var.ilb_name}-hc"
    interval_check          = 2
    timeout                 = 2
    depends_on              = ["module.managed-ig"]
}

##################################################################