resource "aws_route53_record" "internal_alb" {
  name    = "jenkins-${var.jenkins_instance}.${terraform.workspace}"
  zone_id = local.private_hosted_zone.id
  type    = "A"

  alias {
    name                   = local.internal_alb.dns_name
    zone_id                = local.internal_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "internal_nlb" {
  name    = "jenkins-${var.jenkins_instance}-tcp.${terraform.workspace}"
  zone_id = local.private_hosted_zone.id
  type    = "A"

  alias {
    name                   = aws_lb.internal_nlb.dns_name
    zone_id                = aws_lb.internal_nlb.zone_id
    evaluate_target_health = false
  }
}
