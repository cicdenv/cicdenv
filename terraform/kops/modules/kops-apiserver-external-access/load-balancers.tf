resource "aws_elb" "api_public_clb" {
  name     = "api-${var.cluster_short_name}"
  subnets  = var.public_subnet_ids
  security_groups = [var.apiserver_security_group_id]

  cross_zone_load_balancing = true

  listener {
    instance_port     = 443
    instance_protocol = "TCP"
    lb_port           = 443
    lb_protocol       = "TCP"
  }

  health_check {
    target              = "SSL:443"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
    timeout             = 5
  }

  idle_timeout = 300
}

resource "aws_autoscaling_attachment" "masters_to_external_clb" {
  count = length(var.master_asg_names)

  elb                    = aws_elb.api_public_clb.id
  autoscaling_group_name = var.master_asg_names[count.index]
}
