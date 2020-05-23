output "vpc" {
  value = module.shared_vpc.vpc
}

output "private_dns_zone" {
  value = module.shared_vpc.private_dns_zone
}

output "availability_zones" {
  value = local.availability_zones
}

output "subnets" {
  value = module.shared_vpc.subnets
}

output "route_tables" {
  value = module.shared_vpc.route_tables
}

output "subnet_tags" {
  value = {
    public  = merge(local.cluster_tags, local.public_subnet_tags)
    private = merge(local.cluster_tags, local.private_subnet_tags)
  }
}

output "bastion_service" {
  value = {
    security_group = {
      id = aws_security_group.bastion.id
    }
  }
}

output "bastion_events" {
  value = {
    security_group = {
      id = aws_security_group.events.id
    }
  }
}
