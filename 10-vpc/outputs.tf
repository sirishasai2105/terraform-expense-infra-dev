output "vpc_id" {
    value = module.vpc.vpc_id
}

output "subnet" {
    value = module.vpc.subnet_ids
}

output "db-subnet-ids" {
    value = module.vpc.database_subnet_id
}