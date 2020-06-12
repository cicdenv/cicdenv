resource "aws_launch_template" "jenkins_agent" {
  name_prefix   = "jenkins-agent-${var.jenkins_instance}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = var.user_data
  key_name      = local.key_pair.key_name

  iam_instance_profile {
    arn = local.instance_profile.arn
  }
  vpc_security_group_ids = [local.security_group.id]

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

resource "aws_autoscaling_group" "jenkins_agents" {
  name             = "jenkins-agents-${var.jenkins_instance}"
  max_size         = 1
  min_size         = 1
  desired_capacity = 1
  
  launch_template {
    name    = aws_launch_template.jenkins_agent.name
    version = "$Latest"
  }
  
  vpc_zone_identifier = values(local.subnets["private"]).*.id
  
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
