data "local_file" "ssh_key" {
  filename = pathexpand(var.ssh_key)
}

resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = data.local_file.ssh_key.content
}

resource "aws_launch_configuration" "bastion" {
  name_prefix                 = "bastion-lc-"
  image_id                    = var.ami
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.bastion.arn
  security_groups             = [aws_security_group.bastion.id]
  user_data                   = data.template_cloudinit_config.config.rendered
  key_name                    = aws_key_pair.bastion.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                 = "bastion-${terraform.workspace}"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.bastion.name
  vpc_zone_identifier  = var.private_subnets
  target_group_arns    = [
    aws_lb_target_group.bastion_service.arn,
    aws_lb_target_group.bastion_host.arn,
  ]
  
  tags = [
    {
      key                 = "Name"
      value               = "bastion-${terraform.workspace}"
      propagate_at_launch = true
    },
  ]
}