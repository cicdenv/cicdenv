resource "aws_route53_zone_association" "private" {
  zone_id = local.private_hosted_zone.zone_id
  vpc_id  = module.shared_vpc.vpc.id
}
