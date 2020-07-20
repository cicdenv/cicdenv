resource "aws_launch_template" "mysql_server" {
  name_prefix   = "mysql-${var.name}-${var.id}-"
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

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 100
      volume_type = "gp2"

      delete_on_termination = true
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdf"

    ebs {
      volume_size = 1000
      volume_type = "gp2"

      delete_on_termination = true
    }
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "mysql_server" {
  name             = "mysql-${var.name}-${var.id}"
  max_size         = 1
  min_size         = 1
  desired_capacity = 1
  
  launch_template {
    name    = aws_launch_template.mysql_server.name
    version = "$Latest"
  }
  
  vpc_zone_identifier = values(local.subnets["private"]).*.id

  target_group_arns = [
    aws_lb_target_group.mysql_internal.arn,
  ]
  
  tags = [
    {
      key                 = "Name"
      value               = "mysql-${var.name}-${var.id}"
      propagate_at_launch = true
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}
