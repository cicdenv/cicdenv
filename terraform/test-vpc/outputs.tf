output "vpc" {
  value = module.test_vpc.vpc
}

output "private_dns_zone" {
  value = {
    name         = aws_route53_zone.private.name
    zone_id      = aws_route53_zone.private.zone_id
    name_servers = aws_route53_zone.private.name_servers

    # .name with trailing dot stripped
    domain = replace(aws_route53_zone.private.name, "/\\.$/", "")
  }
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
