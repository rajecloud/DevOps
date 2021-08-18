
variable "organization_id" {
  description = "The resource name of the parent Folder or Organization. Must be of the form folders/{folder_id} or organizations/{org_id}"
}

variable "names" {
  type        = list(string)
  description = "Names of the Parent Folders."
  default     = []
}

variable "parent_folder_id" {
  type        = string
  description = "Id of the parent folder under which the sub folder will be placed."
}