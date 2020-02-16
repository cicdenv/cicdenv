resource "aws_security_group" "jenkins_server_external_alb" {
  name   = "jenkins-server-external-alb"
  vpc_id = local.vpc_id

  description = "jenkins dedicated server host"
      
  tags = {
    Name = "jenkins-server external alb"
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

# https
