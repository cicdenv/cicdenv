resource "aws_lb" "internal_nlb" {
  name               = "jenkins-server-${var.jenkins_instance}-internal-nlb"
  load_balancer_type = "network"
  subnets            = local.private_subnets

  internal = true

  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "internal_ssh" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  
  protocol          = "TCP"
  port              = 22

  default_action {
    target_group_arn = aws_lb_target_group.internal_ssh.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "internal_ssh" {
  name     = "jenkins-${var.jenkins_instance}-ssh"
  vpc_id   = local.vpc_id

  protocol = "TCP"
  port     = 16022

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10

    protocol            = "TCP"
    port                = 16022
  }
}

resource "aws_lb_listener" "internal_agent" {
  load_balancer_arn = aws_lb.internal_nlb.arn

  protocol          = "TCP"
  port              = 5000

  default_action {
    target_group_arn = aws_lb_target_group.internal_agents.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "internal_agents" {
  name     = "jenkins-${var.jenkins_instance}-agents"
  vpc_id   = local.vpc_id

  protocol = "TCP"
  port     = 5000

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10

    protocol            = "TCP"
    port                = 5000
  }
}
