variable "project_name" {
  description = "Name of the project."
}

variable "project_id" {
  description = "ID of the new project. If not given default <random-id> will be used"
}

variable "host_project_id" {
  description = "ID of the host project."
}

variable "folder_id" {
  description = "ID of the parent folder where this project needs to be created"
}

variable "billing_account" {
  description = "Billing account ID for the host project, from `gcloud beta billing accounts list`"
}

variable "service_project" {
  description = "Select true, if you want to associate the created project as service projects"
  type        = bool
  default     = false
}