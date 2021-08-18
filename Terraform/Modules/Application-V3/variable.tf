# variable "parent_folder_id" {
#   description = "Parent folder id or name which was already created to create a new nested folder underneath it"
# }

# variable "team_folder_name" {
#     description = "Name of the Team Folders which needs to to be created"
# }

# variable "realm_folder_name" {
#     description = "Name of the Realm Folders which needs to to be created"
# }

# variable "realm_folder_values" {
#     description = "Name of the Realm Folders which is going to be point out as a project name"
#     type = map(string)
#     default = {
#         corp    = "${var.team_folder_name}-c00"
#         prod    = "${var.team_folder_name}-p00"
#         sys     = "${var.team_folder_name}-s00"
#         test    = "${var.team_folder_name}-t00"
#     }
# }

# variable "project_name" {
#   description = "Name of the project."
# }

# variable "service_project__id" {
#   description = "ID of the new project. If not given default <random-id> will be used"
#   default     = ""
# }

# variable "service_project_condition" {
#   description = "Select true, if you want to associate the created project as service projects"
#   type        = bool
#   default     = false
# }


# variable "service_project__name" {
#   description = "Name of the new project. If not given default will be used"
# }

# variable "gcp_billing_account" {
#   description = "Billing account ID for the host project, from `gcloud beta billing accounts list`"
# }


variable "project_id" {
  description = "The ID of the host project where this VPC will be created"
}

variable "vpc_name" {
  description = "The name of the network being created"
}

variable "ip_range"{
  description = "The subnetwork range being created"
}

variable "region"{
  description ="The name of the subnetwork region being created"
}

variable "db_name" {
    description = "The name of the database in the Cloud SQL instance. This does not include the project ID or instance name."
}

variable "db_ins_name" {
    description = "The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created."
}

variable "db_version" {
    description = "The MySQL, PostgreSQL or SQL Server (beta) version to use. Default: MYSQL_5_6"
}

variable "db_mac_type" {
    description = "The machine type to use."
}

variable "db_user_creation" {
  description = "Set this as true to create a db user while creating the db."
  type = bool
  default = false
}

variable "db_username" {
  description = "The name of the user for the database"
}

variable "db_pwd" {
  description = "The password of the user for the database"
}

variable "db_size" {
  description = "The size of the database"
}

variable "gcs_name" {
  description = "Name of the gcs bucket"
} 

variable "gcs_retention_policy" {
  description = "How many seconds the gcs data to be retained in gcs bucket"
}   

variable "gcs_lc_type" {
    description = "Lifecycle type for the gcs bucket"
}  

variable "gcs_lc_age" {
    description = "Age for the gcs bucket after the data to be deleted"
}
