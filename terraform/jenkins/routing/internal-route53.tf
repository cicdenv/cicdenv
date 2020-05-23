resource "aws_route53_record" "internal_dns" {
  name    = "jenkins.${terraform.workspace}"
  zone_id = local.private_hosted_zone.zone_id
  type    = "A"

  alias {
    name                   = aws_lb.jenkins_internal.dns_name
    zone_id                = aws_lb.jenkins_internal.zone_id
    evaluate_target_health = false
  }
}
