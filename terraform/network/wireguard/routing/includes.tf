data "aws_route53_zone" "public_main" {
  name = "${var.domain}."
}
