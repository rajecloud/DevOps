################# Google Cloud Provider ###################

provider "google" {
    version = "3.20.0"
    #region  = var.region
}

############### Folders Creation ################

# module "team_folder" {
#     source              = ""
#     folder_name         = var.team_folder_name
#     parent_folder       = var.parent_folder_id
# }

# module "realm_folder" {
#     source              = ""
#     folder_name         = var.realm_folder_name
#     parent_folder       = module.team_folder.folder_id
#     depends_on          = ["module.team_folder"]
# }

# ################ Service Project ###################

# module "project" {
#     source                      = ""
#     service_project             = var.service_project_condition
#     #for_each                    = { for value in var.realm_folder_values: value.corp => value }
#     #project_name                = var.realm_folder_name == "corp" ? each.value.corp || var.realm_folder_name == "prod" ? each.value.prod || var.realm_folder_name == "sys" ? each.value.sys || var.realm_folder_name == "test" ? each.value.test
#     project_name                = var.project_name
#     project_id                  = var.sp_id
#     folder_id                   = module.folder1.name
#     billing_account             = var.gcp_billing_account
#     auto_create_sub_network     = false
#     depends_on                  = ["module.folder2"]
# }

# ################### Service Account #####################

# module "sa" {
#     source              = ""
#     account_id          = var.sa_account_id
#     display_name        = "${var.vpc_name}-sa"
#     project_id          = var.project_id  #project_id  = module.project.service_project_id
#     iam_roles           = [var.iam_roles]
#     #depends_on          = ["module.project"]
# }

################## VPC #######################

module "vpc1" {
    source                                  = "../../vpc"
    network_name                            = "${var.vpc_name}-1"
    host_project_id                         = var.project_id  #project_id  = module.project.service_project_id
    auto_create_subnetworks                 = false
    routing_mode                            = "GLOBAL"
    delete_default_routes_on_create         = false
    #depends_on                              = ["module.project"]
}

module "vpc2" {
    source                                  = "../../vpc"
    network_name                            = "${var.vpc_name}-2"
    host_project_id                         = var.project_id  #project_id  = module.project.service_project_id
    auto_create_subnetworks                 = false
    routing_mode                            = "GLOBAL"
    delete_default_routes_on_create         = false
    #depends_on                              = ["module.project"]
}
#################### Subnet ######################

module "subnet1" {
    source                     = "../../subnet"
    subnetwork_name            = "${var.vpc_name}-subnets-east"
    ip_cidr_range              = var.ip_range_east
    network_name               = "${var.vpc_name}-1"    #network_name  = module.vpc1.network_id
    region                     = var.region1
    host_project_id            = var.project_id  #project_id  = module.project.service_project_id
    depends_on                 = ["module.vpc1"]
}

module "subnet2" {
    source                     = "../../subnet"
    subnetwork_name            = "${var.vpc_name}-subnets-central"
    ip_cidr_range              = var.ip_range_central
    network_name               = "${var.vpc_name}-2"    #network_name  = module.vpc2.network_id
    region                     = var.region2
    host_project_id            = var.project_id  #project_id  = module.project.service_project_id
    depends_on                 = ["module.vpc2"]
}

################### Firewall Rules #######################

module "firewall_rules1"{
    source           = "../../firewall"
    firewall_name    = "${var.vpc_name}-east-rules"
    network_id       = "${var.vpc_name}-1"     #network_name  = module.vpc1.network_id
    project_id       = var.project_id   #project_id  = module.project.service_project_id
    protocol         = "tcp"
    ports            = var.firewall_ports
    source_tags      = [var.source_tags1]
    target_tags      = [var.target_tags1]
    source_ranges    = ["${var.fw_ip_ranges}"]
    depends_on       = ["module.subnet1"]
}

module "firewall_rules2"{
    source           = "../../firewall"
    firewall_name    = "${var.vpc_name}-central-rules"
    network_id       = "${var.vpc_name}-2"     #network_name  = module.vpc2.network_id
    project_id       = var.project_id   #project_id  = module.project.service_project_id
    protocol         = "tcp"
    ports            = var.firewall_ports
    source_tags      = [var.source_tags2]
    target_tags      = [var.target_tags2]
    source_ranges    = ["${var.fw_ip_ranges}"]
    depends_on       = ["module.subnet2"]
}


################### Primary Appliance GCE ####################

module "instance1" {
    source                      = "../../gce"
    instance_name               = var.instance1_name
    machine_type                = var.mac_type
    network                     = "${var.vpc_name}-1"  #network_name  = module.vpc1.network_id
    subnetwork                  = "${var.vpc_name}-subnets-east" #subnetwork = module.subnet1.subnet_id
    auto_delete                 = true  
    disk_size                   = var.disk_size
    disk_type                   = "pd-standard" #Default is pd-standard
    image                       = var.image
    on_host_maintenance_policy  = "MIGRATE"
    description                 = "GitHub GCE Primary Appliance (Active) Instance"
    label_value                 = var.environment
    project_id                  = var.project_id    #project_id  = module.project.service_project_id
    tags                        = [var.instance1_tags]
    zone                        = var.zone1
    #service_account             = module.sa.sa_email
    depends_on                  = ["module.subnet1"]
}

################### Secondary Appliance GCE ####################

module "instance2" {
    source                      = "../../gce"
    instance_name               = var.instance2_name
    machine_type                = var.mac_type
    network                     = "${var.vpc_name}-1"  #network_name  = module.vpc1.network_id
    subnetwork                  = "${var.vpc_name}-subnets-east" #subnetwork = module.subnet1.subnet_id
    auto_delete                 = true  
    disk_size                   = var.disk_size
    disk_type                   = "pd-standard" #Default is pd-standard
    image                       = var.image
    on_host_maintenance_policy  = "MIGRATE"
    description                 = "GitHub GCE Secondary Appliance (Active) Instance"
    label_value                 = var.environment
    project_id                  = var.project_id    #project_id  = module.project.service_project_id
    tags                        = [var.instance2_tags]
    zone                        = var.zone2
    #service_account             = module.sa.sa_email
    depends_on                  = ["module.subnet1"]
}

################### On Demand Infrastructure GCE ####################

module "instance3" {
    source                      = "../../gce"
    instance_name               = var.instance3_name
    machine_type                = var.mac_type
    network                     = "${var.vpc_name}-2"  #network_name  = module.vpc1.network_id
    subnetwork                  = "${var.vpc_name}-subnets-central" #subnetwork = module.subnet2.subnet_id
    auto_delete                 = true  
    disk_size                   = var.disk_size
    disk_type                   = "pd-standard" #Default is pd-standard
    image                       = var.image
    on_host_maintenance_policy  = "MIGRATE"
    description                 = "GitHub GCE On Demand Infrastructure Instance"
    label_value                 = var.environment
    project_id                  = var.project_id    #project_id  = module.project.service_project_id
    tags                        = [var.instance3_tags]
    zone                        = var.zone3
    #service_account             = module.sa.sa_email
    depends_on                  = ["module.subnet2"]
}


#################### GCS Bucket ##########################

module "gcs_bucket1" {
    source              = "../../bucket"
    bucket_name         = "${var.gcs_name}-1"
    location            = "US"
    project_id          = var.project_id    #project_id  = module.project.service_project_id
    storage_class       = "MULTI_REGIONAL"
    force_destroy       = false
    retention_policy    = var.gcs_retention_policy
    lifecycle_type      = var.gcs_lc_type
    age                 = var.gcs_lc_age
    version_enabled     = false
    depends_on          = ["module.instance1","module.instance2"]
}

module "gcs_bucket2" {
    source              = "../../bucket"
    bucket_name         = "${var.gcs_name}-2"
    location            = "US"
    project_id          = var.project_id    #project_id  = module.project.service_project_id
    storage_class       = "MULTI_REGIONAL"
    force_destroy       = false
    retention_policy    = var.gcs_retention_policy
    lifecycle_type      = var.gcs_lc_type
    age                 = var.gcs_lc_age
    version_enabled     = false
    depends_on          = ["module.instance3"]
}

#################### Internal Load Balancer #######################

module "ilb1" {
    source                  = "../../lb"
    lb_name                 = "${var.ilb_name}-east"
    service_project_id      = var.project_id    #project_id  = module.project.service_project_id
    region                  = var.region1
    #all_ports               = var.all_ports
    lb_scheme               = "INTERNAL"
    network_id              = "${var.vpc_name}-1"  #network_name  = module.vpc1.network_id
    subnetwork_id           = "${var.vpc_name}-subnets-east"
    protocol                = "TCP"
    ports                   = var.lb_ports
    http_hc_port            = var.ilb_hc_ports
    health_check_name       = "${var.ilb_name}-east-hc"
    interval_check          = 2
    timeout                 = 2
    depends_on              = ["module.instance1","module.instance2"]
}

module "ilb2" {
    source                  = "../../lb"
    lb_name                 = "${var.ilb_name}-central"
    service_project_id      = var.project_id    #project_id  = module.project.service_project_id
    region                  = var.region2
    #all_ports               = var.all_ports
    lb_scheme               = "INTERNAL"
    network_id              = "${var.vpc_name}-2"  #network_name  = module.vpc1.network_id
    subnetwork_id           = "${var.vpc_name}-subnets-central"
    protocol                = "TCP"
    ports                   = var.lb_ports
    http_hc_port            = var.ilb_hc_ports
    health_check_name       = "${var.ilb_name}-central-hc"
    interval_check          = 2
    timeout                 = 2
    depends_on              = ["module.instance3"]
}

##################################################################