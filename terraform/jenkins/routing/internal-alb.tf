resource "aws_lb" "jenkins_internal" {
  name               = "jenkins-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.security_groups["internal_alb"].id]
  subnets            = values(local.subnets["private"]).*.id

  idle_timeout = 4000
  enable_http2 = false

  access_logs {
    bucket  = local.jenkins_builds_s3_bucket.id
    enabled = true
  }
}

resource "aws_lb_listener" "jenkins_internal_http" {
  load_balancer_arn = aws_lb.jenkins_internal.arn

  protocol = "HTTP"
  port     = "80"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "jenkins_internal_https" {
  load_balancer_arn = aws_lb.jenkins_internal.arn

  protocol          = "HTTPS"
  port              = "443"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.acm_certificate.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = data.template_file.default_action_page.rendered
      status_code  = 200
    }
  }
}
