output "external_lb" {
  value = {
    fqdn = "${aws_route53_record.dns.name}.${local.public_zone.domain}"
  }
}
