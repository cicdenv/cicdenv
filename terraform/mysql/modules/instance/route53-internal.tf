resource "aws_route53_record" "mysql_internal_nlb" {
  name    = "${var.name}"
  zone_id = local.private_hosted_zone.zone_id
  type    = "A"

  alias {
    name                   = aws_lb.mysql_internal.dns_name
    zone_id                = aws_lb.mysql_internal.zone_id
    evaluate_target_health = false
  }
}
