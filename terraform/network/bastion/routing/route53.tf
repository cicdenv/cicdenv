resource "aws_route53_record" "bastion" {
  name    = "bastion"
  zone_id = local.public_hosted_zone.zone_id
  type    = "A"

  alias {
    name    = aws_lb.bastion.dns_name
    zone_id = aws_lb.bastion.zone_id

    evaluate_target_health = true
  }
}
