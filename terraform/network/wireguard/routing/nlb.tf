resource "aws_lb" "wireguard" {
  name               = "wireguard-nlb"
  load_balancer_type = "network"
  subnets            = values(local.subnets["public"]).*.id

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "wireguard" {
  load_balancer_arn = aws_lb.wireguard.arn
  protocol          = "UDP"
  port              = 51820

  default_action {
    target_group_arn = aws_lb_target_group.wireguard.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "wireguard" {
  name     = "wireguard"
  protocol = "UDP"
  port     = 51820
  vpc_id   = local.vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    protocol            = "TCP"
    port                = 22
  }

  lifecycle {
    create_before_destroy = true
  }
}
