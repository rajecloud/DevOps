variable "bucket_name" {
  description = "Name of the bucket"
}

variable "project_id" {
  description = "Name of the project"
}

variable "location" {
  description = "Location of the bucket, Should be like i.e EU, US"
}

variable "storage_class" {
  description = "The Storage Class of the new bucket. Default : STANDARD, Supported values include: STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE."
}

variable "force_destroy" {
  description = "When deleting a bucket, this boolean option will delete all contained objects.Default: false"
}

variable "retention_policy" {
  description = "The period of time, in seconds, that objects in the bucket must be retained and cannot be deleted, overwritten, or archived. The value must be less than 2,147,483,647 seconds."
}

variable "lifecycle_type" {
  description = "The type of the action of this Lifecycle Rule. Supported values include: Delete and SetStorageClass."
}

variable "age" {
  description = "Minimum age of an object in days to satisfy this condition."
}

variable "version_enabled" {
  description = "While set to true, versioning is fully enabled for this bucket."
}