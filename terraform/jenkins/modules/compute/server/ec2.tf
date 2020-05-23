resource "aws_launch_configuration" "jenkins_server" {
  name_prefix          = "jenkins-server-${var.jenkins_instance}-"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = var.instance_profile_arn
  security_groups      = [local.security_group.id]
  user_data            = var.user_data
  key_name             = local.key_pair.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jenkins_server" {
  name                 = "jenkins-server-${var.jenkins_instance}"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  
  launch_configuration = aws_launch_configuration.jenkins_server.name
  
  vpc_zone_identifier = values(local.subnets["private"]).*.id

  target_group_arns = [
    aws_lb_target_group.internal_https.arn,
    aws_lb_target_group.external_https.arn,
  ]
  
  tags = [
    {
      key                 = "Name"
      value               = "jenkins-server-${var.jenkins_instance}"
      propagate_at_launch = true
    },
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}
