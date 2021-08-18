variable "parent_folder" {
  description = "Parent folder id or name which was already created to create a new nested folder underneath it"
}

variable "org_lookup" {
  description = "Set it as False, if you don't want to lookup the org id to create the folder underneath it"
  default = true
}

variable "folder_name" {
  description = "The Sub folder’s display name. A folder’s display name must be unique amongst its siblings, e.g. no two folders with the same parent can share the same display name. The display name must start and end with a letter"
}
