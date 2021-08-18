

################# Google Cloud Provider ###################

provider "google" {
    version = "3.20.0"
    region  = var.region
}

############### Folders Creation ################

###### Creating Folders in two ways, so choose either of one below #######

## First Way ###

# module "folder1" {
#     source              = ""
#     folder_name         = "product_onboarding"
#     parent_folder       = var.parent_folder_id
# }

# module "folder2" {
#     source              = ""
#     folder_name         = "shared_infra_team"
#     parent_folder       = var.parent_folder_id
# }

# module "folder3" {
#     source              = ""
#     folder_nam          = "sys"
#     parent_folder       =  module.folder1.name
# }

# module "folder4" {
#     source              = ""
#     folder_nam          = "prod"
#     parent_folder       =  module.folder1.name
# }

# module "folder5" {
#     source              = ""
#     folder_nam          = "test"
#     parent_folder       =  module.folder1.name
# }

#####################################################

### Second Way ###

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

################ Service Project ###################

# module "project" {
#     source                      = ""
#     service_project             = var.service_project_condition
#     project_name                = var.service_project__name
#     project_id                  = var.service_project_id
#     folder_id                   = module.folder4.name
#     billing_account             = var.gcp_billing_account
#     auto_create_sub_network     = var.auto_create_network
#     #depends_on                  = ["module.folder4"]
# }


################## VPC #######################

module "vpc" {
    source                                  = "../vpc"
    network_name                            = var.vpc_name
    host_project_id                         = var.project_id #project_id = module.project.project_id
    auto_create_subnetworks                 = false
    routing_mode                            = "GLOBAL"
    delete_default_routes_on_create         = false
    #depends_on                              = ["module.prod_host_project"]
}

#################### Subnet ######################

module "subnet" {
    source                     = "../subnet"
    subnetwork_name            = "${var.vpc_name}-subnets"
    ip_cidr_range              = var.ip_range
    network_name               = var.vpc_name #network_name = module.vpc.network_id
    region                     = var.region
    host_project_id            = var.project_id #project_id = module.project.project_id
    depends_on                 = ["module.vpc"]
}

#################### Private Service Connection ######################

module "net_scon" {
    source          = "../service"
    ip_name         = "${var.vpc_name}-service"
    purpose         = "VPC_PEERING"
    project_id      = var.project_id #project_id = module.project.project_id
    add_type        = "INTERNAL"
    prefix_length   = 16
    network_id      = var.vpc_name #network_name = module.vpc.network_id
    depends_on      = ["module.vpc","module.subnet"]
}

################ Cloud SQL DB ######################

module "cloudsql_db" {
    source                      = "../cloudsql"
    db_name                     = var.db_name
    project_id                  = var.project_id #project_id = module.project.project_id
    db_instance_name            = var.db_ins_name
    region                      = var.region
    db_version                  = var.db_version
    db_machine_type             = var.db_mac_type
    db_ha_type                  = "ZONAL"
    db_disk_size                = var.db_size
    ipv4_enabled                = false
    network_id                  = "projects/${var.project_id}/global/networks/${var.vpc_name}"
    binary_log_enabled          = true
    back_conf_enabled           = true
    db_user_creation            = true #Set it as true if User needs to be created
    db_user_name                = var.db_username
    db_password                 = var.db_pwd
    depends_on                  = ["module.vpc","module.subnet"]
}

#################### GCS Bucket ##########################

module "gcs_bucket1" {
    source              = "../../bucket"
    bucket_name         = var.gcs_name
    location            = "US"
    project_id          = var.project_id    #project_id  = module.project.service_project_id
    storage_class       = "REGIONAL"
    force_destroy       = false
    retention_policy    = var.gcs_retention_policy
    lifecycle_type      = var.gcs_lc_type
    age                 = var.gcs_lc_age
    version_enabled     = false
    depends_on          = ["module.cloudsql_db"]
}

######################################################################

