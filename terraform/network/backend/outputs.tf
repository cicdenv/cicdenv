output "transit_gateways" {
  value = {
    internet = {
      id  = aws_ec2_transit_gateway.internet.id
      arn = aws_ec2_transit_gateway.internet.arn

      default = {
        route_tables = {
          association = {
            id = aws_ec2_transit_gateway.internet.association_default_route_table_id
          }
          propagation = {
            id = aws_ec2_transit_gateway.internet.propagation_default_route_table_id
          }
        }
      }
    }
  }
}

output "availability_zones" {
  value = local.availability_zones
}

output "vpc" {
  value = module.vpc.vpc
}

output "private_dns_zone" {
  value = {
    name         = aws_route53_zone.private.name
    zone_id      = aws_route53_zone.private.zone_id

    # .name with trailing dot stripped
    domain       = replace(aws_route53_zone.private.name, "/\\.$/", "")
  }
}

output "private_dns_zone_ecr_vpce" {
  value = {
    name         = aws_route53_zone.ecr.name
    zone_id      = aws_route53_zone.ecr.zone_id

    # .name with trailing dot stripped
    domain       = replace(aws_route53_zone.ecr.name, "/\\.$/", "")
  }
}

output "subnets" {
  value = module.vpc.subnets
}

output "route_tables" {
  value = module.vpc.route_tables
}
