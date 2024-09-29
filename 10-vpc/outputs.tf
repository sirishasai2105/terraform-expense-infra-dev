output "vpc_id" {
    value = module.vpc.vpc_id
}

output "subnet" {
    value = module.vpc.subnet_ids
}