variable "project_id" {
  description = "ID of the new project. If not given default <random-id> will be used"
  default     = ""
}

variable "project_services" {
  description = "List of host project services to enable."
  type        = "list"
  default     = []
}

variable "auto_create_network" {
  description = "Create auto subnets in network."
  default     = ""
}

variable "disable_on_destroy" {
  description = "Enabled api resources will be destroyed after deleting the projects."
  default     = ""
}