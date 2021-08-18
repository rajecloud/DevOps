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

variable "region1" {
  description = "The name of the subnetwork region 1 being created"
}

variable "region2" {
  description = "The name of the subnetwork region 2 being created"
}

variable "instance1_name" {
  description = "Name of the first instance which going to be created"
}

variable "instance2_name" {
  description = "Name of the second instance which going to be created"
}

variable "instance3_name" {
  description = "Name of the third instance which going to be created"
}

variable "zone1" {
  description = "1st Availability zone for the regions"
}

variable "zone2" {
  description = "2nd Availability zone for the regions"
}

variable "zone3" {
  description = "3rd Availability zone for the regions"
}

variable "image" {
  description = "Image of the instances to be created"
}

variable "firewall_ports" {
  description = "Firewall ports which needs to be opened at firewall level"
  type  = list(string)
}
                  
variable "mac_type" {
  description = "Machine type for the instances to be created"
}    

variable "disk_size" {
  description = "Size for the instance storage disk"
}
                     
variable "source_tags1" {
  description = "Firewall 1st Source tags to be created for the instance"
}          

variable "target_tags1" {
  description = "Firewall 1st Target tags to be created for the instance"
} 

variable "source_tags2" {
  description = "Firewall 2nd Source tags to be created for the instance"
}          

variable "target_tags2" {
  description = "Firewall 2nd Target tags to be created for the instance"
} 

variable "fw_ip_ranges" {
  description = "IP ranges which are to be allowed for firewall rules"
  #type  = "list"
}

variable "instance1_tags" {
  description = "Primary instance tags to be created for the instance"
} 

variable "instance2_tags" {
  description = "Secondary instance tags to be created for the instance"
} 

variable "instance3_tags" {
  description = "On demand instance tags to be created for the instance"
} 

variable "environment" {
  description = "Name of the environment for the instances to be created"
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
  description = "Load Balancer ports which needs to be opened on load balancer"
  type  = "list"
}

variable "ip_range_east" {
  description = "The subnetwork range of east region being created"
}

variable "ip_range_central" {
  description = "The subnetwork range of central region being created"
}

variable "ilb_hc_ports" {
  description = "Ports to be check for health check from ilb"
}