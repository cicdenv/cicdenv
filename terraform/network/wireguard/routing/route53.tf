resource "aws_route53_record" "wireguard" {
  name    = "wireguard"
  zone_id = local.public_hosted_zone.zone_id
  type    = "A"

  alias {
    name    = aws_lb.wireguard.dns_name
    zone_id = aws_lb.wireguard.zone_id

    evaluate_target_health = true
  }
}
