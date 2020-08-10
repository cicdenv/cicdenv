resource "aws_launch_template" "wireguard" {
  name_prefix   = "wireguard-"
  image_id      = local.ami_id
  instance_type = local.instance_type
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

resource "aws_autoscaling_group" "wireguard" {
  name                 = "wireguard"
  max_size             = 3
  min_size             = 1
  desired_capacity     = 1
  
  launch_template {
    name    = aws_launch_template.wireguard.name
    version = "$Latest"
  }
  
  vpc_zone_identifier  = values(local.subnets["private"]).*.id

  target_group_arns = local.target_group_arns
  
  tags = [
    {
      key                 = "Name"
      value               = "wireguard"
      propagate_at_launch = true
    },
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}
