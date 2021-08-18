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

# variable "sp_id" {
#   description = "ID of the new project. If not given default <random-id> will be used"
#   default     = ""
# }

# variable "gcp_billing_account" {
#   description = "Billing account ID for the host project, from `gcloud beta billing accounts list`"
# }

# variable "service_project_condition" {
#   description = "Select true, if you want to associate the created project as service projects"
#   type        = bool
#   default     = false
# }

# variable "iam_roles" {
#   description = "IAM roles to be assigned on service accountr"
#   type  = list(string)
# }

# variable "sa_account_id" {
#   description = "The ID of the service account to be created"
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
  description = "The name of the subnetwork region being created"
}

variable "instance_name" {
  description = "Name of the instances which going to be created"
}

variable "zone" {
  description = "Availability zone for the regions"
}

variable "image" {
  description = "Image of the instances to be created"
}

variable "firewall_ports" {
  description = "Ports which needs to be opened at firewall level"
  type  = list(string)
}

variable "base_name" {
  description = "Base Name of the instances which going to be created"
}                   
variable "mac_type" {
  description = "Machine type for the instances to be created"
}                    
                     
variable "source_tags" {
  description = "Source tags to be created for the instance"
}          

variable "target_tags" {
  description = "Target tags to be created for the instance"
} 

variable "fw_ip_ranges" {
  description = "IP ranges which are to be allowed for firewall rules"
  type  = list(string)
}

variable "mig_tags" {
  description = "Managed Instance Tags tags to be created for the instance"
} 

variable environment" {
  description = "Name of the environment for the instances to be created"
} 

variable "instance_targets" {
  description = "Target counts for instances to be created"
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

variable "ilb_name" {
  description = "Name of the Load Balancer to be created"
}

variable "lb_ports" {
  description = "Ports which needs to be opened on load balancer"
  type  = list(string)
}
