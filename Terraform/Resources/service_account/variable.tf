variable "display_name" {
    description = "Give the suitable display name for the Service Account" 
}

variable "account_id" {
    description = "The id of the account that this Service Account is going to Use"
}

variable "project_id" {
    description = "The id of the project where this SA will be created"
}

variable "iam_role" {
    description = "IAM roles which need to be asigned for this service account"
    type        = string
}

