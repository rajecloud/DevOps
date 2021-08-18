variable "host_project_id" {
  description = "The ID of the host project where this VPC will be created"
}

variable "network_name" {
  description = "The name of the network being created"
}

variable "routing_mode" {
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "auto_create_subnetworks"{
  description = "When set to true, the network is created in auto subnet mode."
  default     = "false"
}

variable "delete_default_routes_on_create"{
  description = "If set to true, default routes (0.0.0.0/0) will be deleted immediately after network creation. Defaults to false."
}
