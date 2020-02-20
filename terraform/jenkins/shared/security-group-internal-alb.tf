resource "aws_security_group" "jenkins_server_internal_alb" {
  name   = "jenkins-server-internal-alb"
  vpc_id = local.vpc_id

  description = "routing for jenkins dedicated server hosts"
      
  tags = {
    Name = "jenkins-servers internal alb"
  }
}

resource "aws_security_group_rule" "jenkins_alb_internal_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.jenkins_server_internal_alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "jenkins_alb_internal_http" {
  description = "jenkins server vpc internal http access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 80
  to_port     = 80

  security_group_id = aws_security_group.jenkins_server_internal_alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "jenkins_alb_internal_https" {
  description = "jenkins server vpc internal https access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443

  security_group_id = aws_security_group.jenkins_server_internal_alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}
