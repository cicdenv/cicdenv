resource "aws_lb" "bastion" {
  name               = "bastion-nlb"
  load_balancer_type = "network"
  subnets            = var.public_subnets

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "bastion_service" {
  load_balancer_arn = aws_lb.bastion.arn
  protocol          = "TCP"
  port              = var.service_ssh_port

  default_action {
    target_group_arn = aws_lb_target_group.bastion_service.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "bastion_service" {
  name     = "bastion-service"
  protocol = "TCP"
  port     = var.service_ssh_port
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    protocol            = "TCP"
    port                = var.service_ssh_port
  }
}

resource "aws_lb_listener" "ssh_host" {
  load_balancer_arn = aws_lb.bastion.arn
  protocol          = "TCP"
  port              = var.host_ssh_port

  default_action {
    target_group_arn = aws_lb_target_group.bastion_host.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "bastion_host" {
  name     = "bastion-host"
  protocol = "TCP"
  port     = var.host_ssh_port
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    protocol            = "TCP"
    port                = var.host_ssh_port
  }
}
