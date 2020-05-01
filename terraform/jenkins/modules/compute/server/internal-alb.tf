resource "aws_lb_listener_rule" "internal_https" {
  listener_arn = local.internal_alb.https_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_https.arn
  }

  condition {
    host_header {
      values = [
        "jenkins-${var.jenkins_instance}.${local.account_hosted_zone.domain}",
        "builds-${var.jenkins_instance}.${local.account_hosted_zone.domain}",
      ]
    }
  }
}

resource "aws_lb_target_group" "internal_https" {
  name = "jenkins-int-${var.jenkins_instance}"

  vpc_id   = local.vpc_id

  protocol = "HTTPS"
  port     = 443
  
  health_check {
    path = "/metrics/currentUser/ping"
    
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10

    protocol = "HTTPS"
    port     = 443
  }
}
