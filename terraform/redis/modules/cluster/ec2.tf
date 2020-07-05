resource "aws_launch_template" "redis_node" {
  name_prefix   = "redis-node-${var.name}-"
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

resource "aws_autoscaling_group" "redis_node" {
  for_each = toset(local.availability_zones)

  name             = "redis-node-${var.name}-${each.key}"
  max_size         = 1
  min_size         = 1
  desired_capacity = 1
  
  launch_template {
    name    = aws_launch_template.redis_node.name
    version = "$Latest"
  }
  
  vpc_zone_identifier = [local.subnets["private"][each.key].id]
  
  tags = [
    {
      key                 = "Name"
      value               = "redis-node-${var.name}-${each.key}"
      propagate_at_launch = true
    },
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}
