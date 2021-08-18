variable "disk_names" {
  description = "Name of the resource"
}

variable "disk_sizes" {
  description = "Size of the persistent disk, specified in GB. You can specify this field when creating a persistent disk using the sourceImage or sourceSnapshot parameter, or specify it alone to create an empty persistent disk"
}

variable "disk_type" {
  description = "URL of the disk type resource describing which disk type to use to create the disk. Provide this when creating the disk"
  default     = "pd-standard"
}

variable "disk_zones" {
  description = "A reference to the zone where the disk resides"
}

variable "disk_label1_value"{
  description = "Disk Labels"
}

variable "project_id"{
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used"
}

variable "instance_id" {
    description = "Id of the instances"
}