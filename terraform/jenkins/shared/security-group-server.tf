resource "aws_security_group" "jenkins_server" {
  name   = "jenkins-server"
  vpc_id = local.vpc.id

  description = "jenkins dedicated server host"
      
  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_security_group_rule" "jenkins_server_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.jenkins_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "jenkins_server_ssh_from_bastion" {
  description = "jenkins server host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.jenkins_server.id
  source_security_group_id = local.bastion_security_group.id
}

resource "aws_security_group_rule" "jenkins_server_https_from_internal_loadbalancers" {
  description = "jenkins server http access from internal loadbalancers"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443

  security_group_id        = aws_security_group.jenkins_server.id
  source_security_group_id = aws_security_group.jenkins_server_internal_alb.id
}

resource "aws_security_group_rule" "jenkins_server_https_from_external_loadbalancers" {
  description = "jenkins server https access from external loadbalancers"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443

  security_group_id        = aws_security_group.jenkins_server.id
  source_security_group_id = aws_security_group.jenkins_server_external_alb.id
}
