resource "aws_key_pair" "bastion" {
  key_name   = "bastion-service"
  public_key = file(pathexpand(var.ssh_key))
}

resource "aws_launch_template" "bastion" {
  name_prefix   = "bastion-service-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = data.template_cloudinit_config.config.rendered
  key_name      = aws_key_pair.bastion.key_name

  iam_instance_profile {
    arn = aws_iam_instance_profile.bastion.arn
  }
  vpc_security_group_ids = [var.security_group.id]

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

resource "aws_autoscaling_group" "bastion" {
  name                 = "bastion-service"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  
  launch_template {
    name    = aws_launch_template.bastion.name
    version = "$Latest"
  }
  
  vpc_zone_identifier  = var.private_subnets

  target_group_arns    = [
    aws_lb_target_group.bastion_service.arn,
    aws_lb_target_group.bastion_host.arn,
  ]
  
  tags = [
    {
      key                 = "Name"
      value               = "bastion-service"
      propagate_at_launch = true
    },
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}
