output "vpc_id" {
  value = module.vpc.vpc_id
}

output "cidr_block" {
  value = var.network_cidr
}

output "s3_vpc_endpoint_id" {
  value = module.vpc.s3_vpc_endpoint_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "nat_gateway_ips" {
  value = module.vpc.nat_gateway_ips
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "private_dns_zone" {
  value = aws_route53_zone.private.zone_id
}

output "security_group_id" {
  value = aws_security_group.test.id
}

output "instance_profile_arn" {
  value = aws_iam_instance_profile.test.arn
}
