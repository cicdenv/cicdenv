resource "aws_security_group" "jenkins_server_internal_alb" {
  name   = "jenkins-server-internal-alb"
  vpc_id = local.vpc_id

  description = "jenkins dedicated server internal"
      
  tags = {
    Name = "jenkins-server internal alb"
  }
}

resource "aws_security_group_rule" "jenkins_server_internal_alb_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.jenkins_server_internal_alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# https
