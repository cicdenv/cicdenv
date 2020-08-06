output "nat_gateways" {
  value = module.nat_gateways.topology
}

output "vpc_endpoints" {
  value = {
    ecr = module.vpc_endpoints.ecr
  }
}

output "transit_gateway_vpc_attachment" {
  value = {
    internet = {
      id = aws_ec2_transit_gateway_vpc_attachment.internet.id
    }
  }
}
