resource "aws_route53_record" "jenkins_internal_alb" {
  name    = "jenkins-${var.jenkins_instance}.${terraform.workspace}"
  zone_id = local.private_hosted_zone.id
  type    = "A"

  alias {
    name                   = local.internal_alb.dns_name
    zone_id                = local.internal_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "builds_internal_alb" {
  name    = "builds-${var.jenkins_instance}.${terraform.workspace}"
  zone_id = local.private_hosted_zone.id
  type    = "A"

  alias {
    name                   = local.internal_alb.dns_name
    zone_id                = local.internal_alb.zone_id
    evaluate_target_health = false
  }
}
