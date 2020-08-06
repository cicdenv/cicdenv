data "aws_region" "current" {}

data "aws_route53_zone" "public_main" {
  name = "${var.domain}."
}
