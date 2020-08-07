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

resource "aws_route53_zone" "private" {
  name    = "${terraform.workspace}.${var.domain}."
  comment = "${terraform.workspace} account scoped private services"

  vpc {
    vpc_id = local.vpc.id
  }

  tags = {
    Name = "${terraform.workspace}.${var.domain}"
  }

  force_destroy = true # Removes records dynamically added by kops/protokube for etcd that prevent zone destruction
}
