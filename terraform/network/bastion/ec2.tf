resource "aws_key_pair" "bastion" {
  key_name   = "bastion-service"
  public_key = file(pathexpand(local.ssh_key))
}

resource "aws_launch_template" "bastion" {
  name_prefix   = "bastion-service-lt-"
  image_id      = local.ami_id
  instance_type = local.instance_type
  user_data     = data.template_cloudinit_config.config.rendered
  key_name      = aws_key_pair.bastion.key_name

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

resource "aws_autoscaling_group" "bastion" {
  name                 = "bastion-service"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  
  launch_template {
    name    = aws_launch_template.bastion.name
    version = "$Latest"
  }
  
  vpc_zone_identifier  = values(local.subnets["private"]).*.id

  target_group_arns = local.target_group_arns
  
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