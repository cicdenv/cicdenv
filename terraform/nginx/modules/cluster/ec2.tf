resource "aws_launch_template" "nginx_server" {
  name_prefix   = "nginx-server-${var.name}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = data.template_cloudinit_config.config.rendered
  key_name      = "shared"

  iam_instance_profile {
    arn = local.instance_profile.arn
  }
  vpc_security_group_ids = local.security_groups.*.id

  # IMDSv2 - instance metadata service session tokens
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    
    http_put_response_hop_limit = 64
  }
  
  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nginx_server" {
  name             = "nginx-server-${var.name}"
  max_size         = 2 * length(local.availability_zones)
  min_size         = length(local.availability_zones)
  desired_capacity = length(local.availability_zones)
  
  launch_template {
    name    = aws_launch_template.nginx_server.name
    version = "$Latest"
  }
  
  vpc_zone_identifier = values(local.subnets["private"]).*.id

  target_group_arns = [
    aws_lb_target_group.nginx_external.arn,
    aws_lb_target_group.nginx_internal.arn,
  ]
  
  tags = [
    {
      key                 = "Name"
      value               = "nginx-server-${var.name}"
      propagate_at_launch = true
    },
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}
