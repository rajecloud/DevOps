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

variable "zone" {
  description = "The zone that the machine should be created in"
}

variable "network" {
  description = "The name or self_link of the network to attach this interface to. Either network or subnetwork must be provided"
  default     = "default"
}

variable "subnetwork" {
  description = "The name or self_link of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in"
  default     = ""
}

variable "auto_delete" {
  description = "Whether the disk will be auto-deleted when the instance is deleted"
  default     = false
}

variable "disk_size" {
  description = "The size of the image in gigabytes. If not specified, it will inherit the size of its base image"
  default     = ""
}

variable "disk_type" {
  description = "The GCE disk type. May be set to pd-standard or pd-ssd"
  default     = "pd-standard"
}

variable "image" {
  description = "The image from which to initialize this disk. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}."
  default     = ""
}

variable "can_ip_forward" {
  description = "Whether to allow sending and receiving of packets with non-matching source or destination IPs"
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection on this instance"
  default     = false
}

variable "description" {
  description = "A brief description of this resource"
  default     = ""
}

variable "labels" {
  type        = "map"
  description = "A set of key/value label pairs to assign to the instance"
  default     = {}
}

#variable "service_account" {
 # description = "Service account to attach to the instance. Refer below for supported values"
#}

variable "tags" {
  description = "A list of tags to attach to the instance for firewall rules"
}

variable "on_host_maintenance_policy" {
    description = "Maintenance Policy"
}

variable "label_value" {
    description = "Instance Lables"
}
