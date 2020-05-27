output "vpc" {
  value = module.test_vpc.vpc
}

output "private_dns_zone" {
  value = module.test_vpc.private_dns_zone
}

output "availability_zones" {
  value = local.availability_zones
}

output "subnets" {
  value = module.test_vpc.subnets
}

output "route_tables" {
  value = module.test_vpc.route_tables
}

output "nat_gateways" {
  value = module.nat_gateways.topology
}

output "vpc_endpoints" {
  value = {
    s3 = module.vpc_endpoints.s3
    ecr = module.vpc_endpoints.ecr
  }
}

output "security_group" {
  value = {
    id = aws_security_group.test.id
  }
}

output "iam" {
  value = {
    role = {
      name = aws_iam_role.test.name
      arn  = aws_iam_role.test.arn
    }
    instance_profile = {
      arn = aws_iam_instance_profile.test.arn
    }
  }
}
