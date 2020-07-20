resource "aws_lb" "mysql_internal" {
  name               = "mysql-int-${var.name}-${var.id}"
  load_balancer_type = "network"
  subnets            = values(local.subnets["private"]).*.id

  internal = true

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "mysql_internal" {
  load_balancer_arn = aws_lb.mysql_internal.arn
  protocol          = "TCP"
  port              = 3306

  default_action {
    target_group_arn = aws_lb_target_group.mysql_internal.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "mysql_internal" {
  name     = "mysql-internal"
  protocol = "TCP"
  port     = 3306
  vpc_id   = local.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    protocol            = "TCP"
    port                = 3306
  }

  lifecycle {
    create_before_destroy = true
  }
}
