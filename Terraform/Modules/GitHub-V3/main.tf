################# Google Cloud Provider ###################

provider "google" {
    version = "3.52.0"
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

module "primary_vpc" {
    source                                  = "../../vpc"
    network_name                            = "${var.vpc_name}-east"
    host_project_id                         = var.project_id  #project_id  = module.project.service_project_id
    auto_create_subnetworks                 = false
    routing_mode                            = "GLOBAL"
    delete_default_routes_on_create         = false
    #depends_on                              = ["module.project"]
}

module "secondary_vpc" {
    source                                  = "../../vpc"
    network_name                            = "${var.vpc_name}-central"
    host_project_id                         = var.project_id  #project_id  = module.project.service_project_id
    auto_create_subnetworks                 = false
    routing_mode                            = "GLOBAL"
    delete_default_routes_on_create         = false
    #depends_on                              = ["module.project"]
}
#################### Subnet ######################

module "primary_subnet" {
    source                     = "../../subnet"
    subnetwork_name            = "${var.vpc_name}-subnets-east"
    ip_cidr_range              = var.ip_range_east
    network_name               = "${var.vpc_name}-east"    #network_name  = module.vpc1.network_id
    region                     = var.first_region
    host_project_id            = var.project_id  #project_id  = module.project.service_project_id
    depends_on                 = ["module.primary_vpc"]
}

module "secondary_subnet" {
    source                     = "../../subnet"
    subnetwork_name            = "${var.vpc_name}-subnets-central"
    ip_cidr_range              = var.ip_range_central
    network_name               = "${var.vpc_name}-central"    #network_name  = module.vpc2.network_id
    region                     = var.second_region
    host_project_id            = var.project_id  #project_id  = module.project.service_project_id
    depends_on                 = ["module.secondary_vpc"]
}

################### Firewall Rules #######################

module "primary_firewall_rules"{
    source           = "../../firewall"
    firewall_name    = "${var.vpc_name}-east-rules"
    network_id       = "${var.vpc_name}-east"     #network_name  = module.vpc1.network_id
    project_id       = var.project_id   #project_id  = module.project.service_project_id
    protocol         = "tcp"
    udp_ports        = ["1194"]
    ports            = var.firewall_ports
    source_tags      = [var.source_tags1]
    target_tags      = [var.target_tags1]
    source_ranges    = ["${var.fw_ip_ranges}"]
    depends_on       = ["module.primary_subnet"]
}

module "secondary_firewall_rules"{
    source           = "../../firewall"
    firewall_name    = "${var.vpc_name}-central-rules"
    network_id       = "${var.vpc_name}-central"     #network_name  = module.vpc2.network_id
    project_id       = var.project_id   #project_id  = module.project.service_project_id
    protocol         = "tcp"
    udp_ports        = ["1194"]
    ports            = var.firewall_ports
    source_tags      = [var.source_tags2]
    target_tags      = [var.target_tags2]
    source_ranges    = ["${var.fw_ip_ranges}"]
    depends_on       = ["module.secondary_subnet"]
}


################### Primary Appliance GCE ####################

module "primary_instance" {
    source                      = "../../gce"
    instance_name               = var.primary_instance_name
    machine_type                = var.mac_type
    network                     = "${var.vpc_name}-east"  #network_name  = module.vpc1.network_id
    subnetwork                  = "${var.vpc_name}-subnets-east" #subnetwork = module.subnet1.subnet_id
    auto_delete                 = true  
    disk_size                   = var.disk_size
    disk_type                   = "pd-standard" #Default is pd-standard
    image                       = var.image
    on_host_maintenance_policy  = "MIGRATE"
    description                 = "GitHub GCE Primary Appliance (Active) Instance"
    label_value                 = var.environment
    project_id                  = var.project_id    #project_id  = module.project.service_project_id
    tags                        = [var.primary_instance_tags]
    zone                        = var.first_zone
    #service_account             = module.sa.sa_email
    depends_on                  = ["module.primary_subnet"]
}

################### Secondary Appliance GCE ####################

module "secondary_instance" {
    source                      = "../../gce"
    instance_name               = var.secondary_instance_name
    machine_type                = var.mac_type
    network                     = "${var.vpc_name}-east"  #network_name  = module.vpc1.network_id
    subnetwork                  = "${var.vpc_name}-subnets-east" #subnetwork = module.subnet1.subnet_id
    auto_delete                 = true  
    disk_size                   = var.disk_size
    disk_type                   = "pd-standard" #Default is pd-standard
    image                       = var.image
    on_host_maintenance_policy  = "MIGRATE"
    description                 = "GitHub GCE Secondary Appliance (Active) Instance"
    label_value                 = var.environment
    project_id                  = var.project_id    #project_id  = module.project.service_project_id
    tags                        = [var.secondary_instance_tags]
    zone                        = var.second_zone
    #service_account             = module.sa.sa_email
    depends_on                  = ["module.primary_subnet"]
}

################### On Demand Infrastructure GCE ####################

module "ondemand_instance" {
    source                      = "../../gce"
    instance_name               = var.ondemand_instance_name
    machine_type                = var.mac_type
    network                     = "${var.vpc_name}-central"  #network_name  = module.vpc1.network_id
    subnetwork                  = "${var.vpc_name}-subnets-central" #subnetwork = module.subnet2.subnet_id
    auto_delete                 = true  
    disk_size                   = var.disk_size
    disk_type                   = "pd-standard" #Default is pd-standard
    image                       = var.image
    on_host_maintenance_policy  = "MIGRATE"
    description                 = "GitHub GCE On Demand Infrastructure Instance"
    label_value                 = var.environment
    project_id                  = var.project_id    #project_id  = module.project.service_project_id
    tags                        = [var.ondemand_instance_tags]
    zone                        = var.third_zone
    #service_account             = module.sa.sa_email
    depends_on                  = ["module.secondary_subnet"]
}

################ Primary Appliance Instance PD ################

module "first-pd" {
    source              = "../../pd"
    disk_names          = "${var.primary_instance_name}-pd"
    project_id          = var.project_id
    disk_sizes          = var.pd_size
    disk_type           = var.pd_type
    disk_zones          = var.first_zone
    disk_label1_value   = var.environment
    instance_id         = module.primary_instance.instance_id
}

################ Secondary Appliance Instance PD ################

module "second-pd" {
    source              = "../../pd"
    disk_names          = "${var.secondary_instance_name}-pd"
    project_id          = var.project_id
    disk_sizes          = var.pd_size
    disk_type           = var.pd_type
    disk_zones          = var.second_zone
    disk_label1_value   = var.environment
    instance_id         = module.secondary_instance.instance_id
}

################ On Demand Infra Instance PD ################

module "third-pd" {
    source              = "../../pd"
    disk_names          = "${var.ondemand_instance_name}-pd"
    project_id          = var.project_id
    disk_sizes          = var.pd_size
    disk_type           = var.pd_type
    disk_zones          = var.third_zone
    disk_label1_value   = var.environment
    instance_id         = module.ondemand_instance.instance_id
}

#################### Instance Group 1 #####################

module "first_ig" {
    source          = "../../ig"
    ig_name         = "primary-ig"
    zone            = var.first_zone
    description     = "Primary Instance Group"
    project_id      = var.project_id
    network_id      = module.primary_vpc.network_id
    instances_id    = module.primary_instance.instance_link
    protocol        = var.ig_protocol
}

#################### Instance Group 2 #####################

module "second_ig" {
    source          = "../../ig"
    ig_name         = "secondary-ig"
    zone            = var.second_zone
    description     = "Primary Instance Group"
    project_id      = var.project_id
    network_id      = module.primary_vpc.network_id
    instances_id    = module.secondary_instance.instance_link
    protocol        = var.ig_protocol
}

#################### Instance Group 3 #####################

module "third_ig" {
    source          = "../../ig"
    ig_name         = "on-demand-ig"
    zone            = var.third_zone
    description     = "Secondary Instance Group"
    project_id      = var.project_id
    network_id      = module.secondary_vpc.network_id
    instances_id    = module.ondemand_instance.instance_link
    protocol        = var.ig_protocol
}

#################### GCS Bucket ##########################

module "primary_bucket" {
    source              = "../../bucket"
    bucket_name         = "${var.gcs_name}-primary"
    location            = "US"
    project_id          = var.project_id    #project_id  = module.project.service_project_id
    storage_class       = "MULTI_REGIONAL"
    force_destroy       = false
    retention_policy    = var.gcs_retention_policy
    lifecycle_type      = var.gcs_lc_type
    age                 = var.gcs_lc_age
    version_enabled     = false
    depends_on          = ["module.primary_instance","module.secondary_instance"]
}

module "secondary_bucket" {
    source              = "../../bucket"
    bucket_name         = "${var.gcs_name}-secondary"
    location            = "US"
    project_id          = var.project_id    #project_id  = module.project.service_project_id
    storage_class       = "MULTI_REGIONAL"
    force_destroy       = false
    retention_policy    = var.gcs_retention_policy
    lifecycle_type      = var.gcs_lc_type
    age                 = var.gcs_lc_age
    version_enabled     = false
    depends_on          = ["module.ondemand_instance"]
}

#################### Internal Load Balancer #######################

# module "primary_backend" {
#     source              = "../../backend"
#     backend_name        = "${var.ilb_name}-primary-backend"
#     region              = var.first_region
#     service_project_id  = var.project_id    #project_id  = module.project.service_project_id
#     ig_names            = module.first_ig.ig_name
#     health_check_name   = "${var.ilb_name}-primary-hc"
#     interval_check      = 2
#     timeout             = 2
# }

# # module "secondary_backend" {
# #     source              = "../../backend"
# #     backend_name        = "${var.ilb_name}-secondary-backend"
# #     region              = var.first_region
# #     service_project_id  = var.project_id    #project_id  = module.project.service_project_id
# #     ig_names            = module.second_ig.ig_name
# #     health_check_name   = "${var.ilb_name}-secondary-hc"
# #     interval_check      = 2
# #     timeout             = 2
# # }

# module "secondary_backend" {
#     source              = "../../backend"
#     backend_name        = "${var.ilb_name}-ondemand-backend"
#     region              = var.second_region
#     service_project_id  = var.project_id    #project_id  = module.project.service_project_id
#     backends            = module.third_ig.ig_name
#     health_check_name   = "${var.ilb_name}-ondemand-hc"
#     interval_check      = 2
#     timeout             = 2
# }

module "ilb1" {
    source                  = "../../lb"
    lb_name                 = "${var.ilb_name}-east"
    service_project_id      = var.project_id    #project_id  = module.project.service_project_id
    region                  = var.first_region
    all_ports               = true
    backends                = [
        { group = module.first_ig.ig_link },
        { group = module.second_ig.ig_link },
    ]
    lb_scheme               = "INTERNAL"
    network_id              = "${var.vpc_name}-east"  #network_name  = module.vpc1.network_id
    subnetwork_id           = "${var.vpc_name}-subnets-east"
    protocol                = "TCP"
    #ports                   = var.lb_ports
    health_check_name       = "${var.ilb_name}-east-hc"
    interval_check          = 2
    timeout                 = 2
    depends_on              = ["module.primary_instance","module.secondary_instance"]
}

module "ilb2" {
    source                  = "../../lb"
    lb_name                 = "${var.ilb_name}-central"
    service_project_id      = var.project_id    #project_id  = module.project.service_project_id
    region                  = var.second_region
    all_ports               = true
    backends                = [
        { group = module.third_ig.ig_link },
    ]
    lb_scheme               = "INTERNAL"
    network_id              = "${var.vpc_name}-central"  #network_name  = module.vpc1.network_id
    subnetwork_id           = "${var.vpc_name}-subnets-central"
    protocol                = "TCP"
    #ports                   = var.lb_ports
    health_check_name       = "${var.ilb_name}-central-hc"
    interval_check          = 2
    timeout                 = 2
    depends_on              = ["module.ondemand_instance"]
}

##################################################################