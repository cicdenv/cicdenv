data "aws_caller_identity" "current" {}

data "aws_route53_zone" "public_hosted_zone" {
  name = "${var.domain}."
}
