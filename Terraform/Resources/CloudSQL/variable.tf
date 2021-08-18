variable "project_id" {
    description = "Project ID for the service projects. If not given default <random-id> will be used"
}

variable "region" {
    description = "The region the instance will sit in.If a region is not provided in the resource definition, the provider region will be used instead."
}

variable "db_name" {
    description = "The name of the database in the Cloud SQL instance. This does not include the project ID or instance name."
}

variable "db_instance_name" {
    description = "The name of the instance. If the name is left blank, Terraform will randomly generate one when the instance is first created."
}

variable "db_version" {
    description = "The MySQL, PostgreSQL or SQL Server (beta) version to use. Default: MYSQL_5_6"
}

# variable "db_machine_type" {
#     description = "The machine type to use."
# }

variable "db_disk_size" {
    description = "The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased."
}

# variable "db_ha_type" {
#     description = "The availability type of the Cloud SQL instance, high availability (REGIONAL) or single zone (ZONAL).'"
# }

# variable "ipv4_enabled" {
#     description = "Whether this Cloud SQL instance should be assigned a public IPV4 address. Either ipv4_enabled must be enabled or a private_network must be configured."
# }

# variable "network_id" {
#     description = "The VPC network from which the Cloud SQL instance is accessible for private IP"
# }

# variable "db_user_creation" {
#     description = "Set this as true to create a db user while creating the db."
#     type = bool
#     default = false
# }

# variable "db_user_name" {
#     description = "The name of the user for the database"
# }

# variable "db_password" {
#     description = "The password of the user for the database"
# }

# variable "binary_log_enabled" {
#     description = "True if binary logging is enabled. If settings.backup_configuration.enabled is false, this must be as well. Cannot be used with Postgres."
#     default = true
# }

# variable "back_conf_enabled" {
#     description = "True if backup configuration is enabled. Must be true for Mysql not Postgres"
#     default = true
# }

