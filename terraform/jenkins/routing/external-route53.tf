resource "aws_route53_record" "external_dns" {
  name    = "jenkins"
  zone_id = local.account_hosted_zone.id
  type    = "A"

  alias {
    name                   = aws_lb.jenkins_external.dns_name
    zone_id                = aws_lb.jenkins_external.zone_id
    evaluate_target_health = false
  }
}
