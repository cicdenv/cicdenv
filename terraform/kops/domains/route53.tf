resource "aws_route53_zone" "kops_dns_zone" {
  name    = "kops.${var.domain}."
  comment = "KOPS Kubernetes Clusters"
}

resource "aws_route53_record" "kops_dns_ns" {
  zone_id = data.aws_route53_zone.public_main.zone_id
  name    = "kops.${var.domain}"
  type    = "NS"
  ttl     = "30"

  records = aws_route53_zone.kops_dns_zone.name_servers
}
