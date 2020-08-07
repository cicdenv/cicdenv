resource "aws_security_group" "jenkins_server_external_alb" {
  name   = "jenkins-server-external-alb"
  vpc_id = local.vpc.id

  description = "routing for jenkins dedicated server hosts"
      
  tags = {
    Name = "jenkins-servers external alb"
  }
}

resource "aws_security_group_rule" "jenkins_server_external_alb_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.jenkins_server_external_alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "jenkins_alb_external_http" {
  description = "jenkins server external http access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80

  security_group_id = aws_security_group.jenkins_server_external_alb.id
  cidr_blocks       = var.allowed_cidr_blocks
}

resource "aws_security_group_rule" "jenkins_alb_external_https" {
  description = "jenkins server external https access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443

  security_group_id = aws_security_group.jenkins_server_external_alb.id
  cidr_blocks       = var.allowed_cidr_blocks
}

resource "aws_security_group_rule" "jenkins_alb_external_github_hooks" {
  description = "jenkins server external https github webhooks"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443

  security_group_id = aws_security_group.jenkins_server_external_alb.id
  cidr_blocks       = var.github_hooks_cidr_blocks
}
