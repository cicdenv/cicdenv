output "dns" {
  value = "${aws_route53_record.bastion.name}.${local.public_hosted_zone.domain}"
}

output "nlb" {
  value = {
    arn      = aws_lb.bastion.arn
    dns_name = aws_lb.bastion.dns_name
    zone_id  = aws_lb.bastion.zone_id

    target_groups = [
      {
        arn = aws_lb_target_group.bastion_service.arn
      },
      {
        arn = aws_lb_target_group.bastion_host.arn
      },
    ]
  }
}
