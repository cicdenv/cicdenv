output "nat_gateways" {
  value = module.nat_gateways.topology
}

output "vpc_endpoints" {
  value = {
    s3 = module.vpc_endpoints.s3
    ecr = module.vpc_endpoints.ecr
  }
}
