variable "service_project_id" {
  description = "The service project ID to create the resources in."
}

variable "region" {
  description = "All resources will be launched in this region."
}

variable "lb_name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
}

# variable "ports" {
#   description = "List of ports (or port ranges) to forward to backend services. Max is 5."
#   type        = "list"
#   default     = []
# }

variable "all_ports" {
  description = "Allow all ports"
  default = false
}

variable "protocol" {
  description = "The protocol for the backend and frontend forwarding rule. TCP or UDP."
  type        = string
  default     = "TCP"
}

variable "network_id" {
  description = "Self link of the VPC network in which to deploy the resources."
  type        = string
  default     = "default"
}

variable "lb_scheme" {
  description = "Scheme of the Load Balancer, INTERNAL OR EXTERNAL "
  default     = "INTERNAL"
}

variable "subnetwork_id" {
  description = "Id or Self link for the subnet"
  default = ""
}

variable "health_check_name" {
  description = "Name for the health check that load balancer will be going to use oftenly"
}

variable "interval_check" {
  description = "How many intervels health check to be passed"
  default     = 2
}
variable "timeout" {
  description = "How many timeouts to be set for hc"
  default = 10
}

variable "backends" {
  description = "List of backends, should be a map of key-value pairs for each backend, must have the 'group' key."
  type        = list(object({ group = string }))
}