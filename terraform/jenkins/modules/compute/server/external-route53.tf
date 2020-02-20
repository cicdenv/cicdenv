resource "aws_route53_record" "jenkins_external_alb" {
  name    = "jenkins-${var.jenkins_instance}"
  zone_id = local.account_hosted_zone.id
  type    = "A"

  alias {
    name                   = local.external_alb.dns_name
    zone_id                = local.external_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "builds_external_alb" {
  name    = "builds-${var.jenkins_instance}"
  zone_id = local.account_hosted_zone.id
  type    = "A"

  alias {
    name                   = local.external_alb.dns_name
    zone_id                = local.external_alb.zone_id
    evaluate_target_health = false
  }
}
