
output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnets_ids" {
    value = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
    value = module.vpc.private_subnets_ids
}

output "db_subnets_ids" {
    value = module.vpc.db_subnets_ids
}
