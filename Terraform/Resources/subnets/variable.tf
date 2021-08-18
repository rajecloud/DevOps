variable "host_project_id" {
  description = "The ID of the host project where this VPC will be created"
}

variable "network_name" {
  description = "The name of the network being created"
}

variable "subnetwork_name"{
  description = "The name of the subnetwork being created"
}

variable "ip_cidr_range"{
  description = "The subnetwork range being created"
}

variable "region"{
  description ="The name of the subnetwork region being created"
}
