resource "aws_security_group" "jenkins_server" {
  name   = "jenkins-server"
  vpc_id = local.vpc_id

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
  source_security_group_id = local.bastion_service_security_group_id
}

resource "aws_security_group_rule" "jenkins_server_ssh_from_nlb" {
  description = "jenkins server host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 16022
  to_port     = 16022

  security_group_id = aws_security_group.jenkins_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "jenkins_server_jnlp_from_agent" {
  description = "jenkins server agent access from dedicated hosts"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 5000
  to_port     = 5000

  security_group_id        = aws_security_group.jenkins_server.id
  source_security_group_id = aws_security_group.jenkins_agent.id
}

resource "aws_security_group_rule" "jenkins_server_jnlp_from_kops" {
  description = "jenkins server agent access from kops nodes"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 5000
  to_port     = 5000

  security_group_id        = aws_security_group.jenkins_server.id
  source_security_group_id = local.kops_node_security_group_id
}

resource "aws_security_group_rule" "jenkins_server_http_from_internal_loadbalancers" {
  description = "jenkins server http access from internal loadbalancers"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 8080
  to_port     = 8080

  security_group_id        = aws_security_group.jenkins_server.id
  source_security_group_id = aws_security_group.jenkins_server_internal_alb.id
}

resource "aws_security_group_rule" "jenkins_server_http_from_external_loadbalancers" {
  description = "jenkins server http access from external loadbalancers"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 8080
  to_port     = 8080

  security_group_id        = aws_security_group.jenkins_server.id
  source_security_group_id = aws_security_group.jenkins_server_external_alb.id
}
