resource "aws_route53_vpc_association_authorization" "private" {
  count = terraform.workspace != "main" ? 1 : 0  # only for cross account

  zone_id = local.private_hosted_zone.zone_id
  vpc_id  = module.shared_vpc.vpc.id

  vpc_region = var.target_region
  
  provider = aws.main
}

resource "aws_route53_zone_association" "private" {
  zone_id = local.private_hosted_zone.zone_id
  vpc_id  = module.shared_vpc.vpc.id
}
