variable "project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used"
  default     = ""
}

variable "ig_name" {
  description = "A name for the instance group, required by GCE"
}

variable "zone" {
  description = "The zone that the machine should be created in"
}

variable "network_id" {
  description = "The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided"
}

variable "description" {
  description = "A brief description of this resource"
}

variable "instances_id" {
  description = "A set of key/value label pairs to assign to the instance"
}

variable "protocol" {
  description = "Protocol to use for instance group hc"
}

