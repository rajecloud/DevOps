variable "service_project_id" {
  description = "The service project ID to create the resources in."
}

variable "region" {
  description = "All resources will be launched in this region."
}

variable "backend_name" {
  description = "Name for the load balancer forwarding rule and prefix for supporting resources."
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

variable "ig_names" {
  description = "Instance group name"
}

variable "backends" {
  description = "List of backends, should be a map of key-value pairs for each backend, must have the 'group' key."
  type        = list(object({ group = string }))
}