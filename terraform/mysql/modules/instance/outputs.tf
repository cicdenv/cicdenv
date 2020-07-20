output "dns" {
  value = "${aws_route53_record.mysql_internal_nlb.name}.${local.private_hosted_zone.domain}"
}

output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.mysql_server.id
    name = aws_autoscaling_group.mysql_server.name
    arn  = aws_autoscaling_group.mysql_server.arn
  }
}
