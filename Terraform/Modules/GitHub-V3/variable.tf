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
  default = "default"
}

variable "first_region" {
  description = "The name of the subnetwork region 1 being created"
}

variable "second_region" {
  description = "The name of the subnetwork region 2 being created"
}

variable "primary_instance_name" {
  description = "Name of the first instance which going to be created"
}

variable "secondary_instance_name" {
  description = "Name of the second instance which going to be created"
}

variable "ondemand_instance_name" {
  description = "Name of the third instance which going to be created"
}

variable "first_zone" {
  description = "1st Availability zone for the regions"
}

variable "second_zone" {
  description = "2nd Availability zone for the regions"
}

variable "third_zone" {
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
  default = 10
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

variable "primary_instance_tags" {
  description = "Primary instance tags to be created for the instance"
} 

variable "secondary_instance_tags" {
  description = "Secondary instance tags to be created for the instance"
} 

variable "ondemand_instance_tags" {
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

# variable "lb_ports" {
#   description = "Load Balancer ports which needs to be opened on load balancer"
#   type  = "list"
# }

variable "ip_range_east" {
  description = "The subnetwork range of east region being created"
}

variable "ip_range_central" {
  description = "The subnetwork range of central region being created"
}

variable "ilb_hc_ports" {
  description = "Ports to be check for health check from ilb"
}

variable "ig_protocol" {
  description = "Protocol for instance group"
  default = "tcp"
}
variable "ig_ports" {
  description = "ports for instance group hc"
  default = "80"
}
variable "pd_size" {
  description = "Disk size (GB) for the instance"
  default = 100
}
variable "pd_type" {
  description = "Disk type for the Instance"
  default = "pd-standard"
}