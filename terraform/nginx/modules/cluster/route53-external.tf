resource "aws_route53_record" "nginx_external_nlb" {
  name    = var.name
  zone_id = local.account_hosted_zone.zone_id
  type    = "A"

  alias {
    name                   = aws_lb.nginx_external.dns_name
    zone_id                = aws_lb.nginx_external.zone_id
    evaluate_target_health = false
  }
}
