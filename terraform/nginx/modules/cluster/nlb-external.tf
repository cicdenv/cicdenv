resource "aws_lb" "nginx_external" {
  name               = "nginx-ext-${var.name}"
  load_balancer_type = "network"
  subnets            = values(local.subnets["public"]).*.id

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "nginx_external" {
  load_balancer_arn = aws_lb.nginx_external.arn
  protocol          = "TCP"
  port              = 443

  default_action {
    target_group_arn = aws_lb_target_group.nginx_external.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "nginx_external" {
  name     = "nginx-external"
  protocol = "TCP"
  port     = 443
  vpc_id   = local.vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    protocol            = "TCP"
    port                = 443
  }

  lifecycle {
    create_before_destroy = true
  }
}
