resource "aws_launch_configuration" "jenkins_agent" {
  name_prefix          = "jenkins-agent-${var.jenkins_instance}-"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  iam_instance_profile = local.instance_profile.arn
  security_groups      = [local.security_group.id]
  user_data            = var.user_data
  key_name             = local.key_pair.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "jenkins_agents" {
  name                 = "jenkins-agents-${var.jenkins_instance}"
  max_size             = 1
  min_size             = 1
  desired_capacity     = 1
  
  launch_configuration = aws_launch_configuration.jenkins_agent.name
  
  vpc_zone_identifier = local.private_subnets
  
  tags = [
    {
      key                 = "Name"
      value               = "jenkins-agent-${var.jenkins_instance}"
      propagate_at_launch = true
    },
  ]
  
  lifecycle {
    create_before_destroy = true
  }
}
