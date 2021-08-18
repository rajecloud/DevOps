variable "project_id" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used"
  default     = ""
}

variable "instance_name" {
  description = "A unique name for the resource, required by GCE"
}

variable "machine_type" {
  description = "The machine type to create"
}

variable "region" {
  description = "The region that the machine should be created in"
}

variable "zone" {
  description = "The zone that the machine should be created in"
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in"
  default     = ""
}

variable "auto_delete" {
  description = "Whether the disk will be auto-deleted when the instance is deleted"
  default     = false
}

variable "disk_condition" {
  description = "Set it true if the disk should need to be used for boot. False will make it as a persistent disk which needs to be attached."
  default     = true
}

variable "image" {
  description = "The image from which to initialize this disk. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}."
  default     = ""
}

variable "can_ip_forward" {
  description = "Whether to allow sending and receiving of packets with non-matching source or destination IPs"
  default     = false
}

variable "description" {
  description = "A brief description of this resource"
}

variable "labels" {
  type        = "map"
  description = "A set of key/value label pairs to assign to the instance"
  default     = {}
}

variable "tags" {
  description = "A list of tags to attach to the instance for firewall rules"
}

variable "on_host_maintenance_policy" {
    description = "Maintenance Policy"
}

variable "label_value" {
    description = "Instance Lables"
}

variable "mig_name" {
    description = "Name of the managed instance group"
}

variable "targets" {
    description = "How many instances to be created, target size"
}

variable "base_name" {}