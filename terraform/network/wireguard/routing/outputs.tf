output "dns" {
  value = "${aws_route53_record.wireguard.name}.${local.public_hosted_zone.domain}"
}

output "nlb" {
  value = {
    arn      = aws_lb.wireguard.arn
    dns_name = aws_lb.wireguard.dns_name
    zone_id  = aws_lb.wireguard.zone_id

    target_groups = [
      {
        arn = aws_lb_target_group.wireguard.arn
      }
    ]
  }
}
