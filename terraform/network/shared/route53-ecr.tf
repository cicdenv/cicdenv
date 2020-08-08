resource "aws_route53_vpc_association_authorization" "private_ecr" {
  count = terraform.workspace != "main" ? 1 : 0  # only for cross account

  zone_id = local.private_dns_zone_ecr_vpce.zone_id
  vpc_id  = module.shared_vpc.vpc.id

  vpc_region = var.target_region
  
  provider = aws.main
}

resource "aws_route53_zone_association" "private_ecr" {
  zone_id = local.private_dns_zone_ecr_vpce.zone_id
  vpc_id  = module.shared_vpc.vpc.id
}
