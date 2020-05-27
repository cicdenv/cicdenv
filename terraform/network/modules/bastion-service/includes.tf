data "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  id    = var.public_subnets[count.index]
}

data "aws_route53_zone" "account_hosted_zone" {
  zone_id = var.zone_id
}
