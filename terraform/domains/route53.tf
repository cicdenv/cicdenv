resource "aws_route53_zone" "account" {
  name    = "${terraform.workspace}.${var.domain}."
  comment = "${terraform.workspace} account scoped services"
}

resource "aws_route53_record" "account_ns" {
  zone_id = data.aws_route53_zone.public_main.zone_id
  name    = "${terraform.workspace}.${var.domain}"
  type    = "NS"
  ttl     = "30"

  records = aws_route53_zone.account.name_servers

  provider = aws.main
}
