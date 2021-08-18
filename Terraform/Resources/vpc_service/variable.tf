variable "ip_name" {
    description = "Name of the resource,the name must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])?."
}
variable "add_type" {
    description = "The type of address to reserve. Default value is EXTERNAL. Possible values are INTERNAL and EXTERNAL."
}
variable "purpose" {
    description = "The purpose of this resource, Possible values are GCE_ENDPOINT, VPC_PEERING, and SHARED_LOADBALANCER_VIP."
}

variable "prefix_length" {
    description = "The length of the bytes"
}
variable "network_id" {
    description = "The network name or self link"
}
variable "project_id" {
    description = "The project name or id"
}