data "aws_route53_zone" "public_hosted_zone" {
  name = "${var.domain}."
}
