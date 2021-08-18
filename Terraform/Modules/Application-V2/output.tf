
output "vpc_id" {
    value = module.vpc.network_id
}

output "subnet_id" {
    value = module.subnet.subnet_id
}

output "db_details" {
    value = module.cloudsql_db
}
