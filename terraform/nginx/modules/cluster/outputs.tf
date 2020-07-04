output "url" {
  value = "https://${aws_route53_record.nginx_external_nlb.name}.${local.account_hosted_zone.domain}"
}

output "autoscaling_group" {
  value = {
    id   = aws_autoscaling_group.nginx_server.id
    name = aws_autoscaling_group.nginx_server.name
    arn  = aws_autoscaling_group.nginx_server.arn
  }
}
