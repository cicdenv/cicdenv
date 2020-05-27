output "dns" {
  value = {
    external = "${aws_route53_record.external_dns.name}.${local.account_hosted_zone.domain}"
    internal = "${aws_route53_record.internal_dns.name}.${local.private_hosted_zone.domain}"
  }
}

output "internal_alb" {
  value = {
    arn = aws_lb.jenkins_internal.arn

    https_listener_arn = aws_lb_listener.jenkins_internal_https.arn

    dns_name = aws_lb.jenkins_internal.dns_name
    zone_id  = aws_lb.jenkins_internal.zone_id
  }
}

output "external_alb" {
  value = {
    arn = aws_lb.jenkins_external.arn

    https_listener_arn = aws_lb_listener.jenkins_external_https.arn

    dns_name = aws_lb.jenkins_external.dns_name
    zone_id  = aws_lb.jenkins_external.zone_id
  }
}
