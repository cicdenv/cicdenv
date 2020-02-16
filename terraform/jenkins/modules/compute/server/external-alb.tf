resource "aws_lb_listener_rule" "external_https" {
  listener_arn = local.external_alb.https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_https.arn
  }

  condition {
    host_header {
      values = [
        "jenkins-${var.jenkins_instance}.${local.account_hosted_zone.domain}",
      ]
    }
  }
}

resource "aws_lb_target_group" "external_https" {
  name     = "jenkins-server-external-https"
  vpc_id   = local.vpc_id

  protocol = "HTTP"
  port     = 8080

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10

    protocol = "HTTP"
    port     = 8080
  }
}
