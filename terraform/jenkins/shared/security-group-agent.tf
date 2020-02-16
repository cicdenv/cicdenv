resource "aws_security_group" "jenkins_agent" {
  name   = "jenkins-agent"
  vpc_id = local.vpc_id

  description = "jenkins dedicated agent host"
      
  tags = {
    Name = "jenkins-agent"
  }
}

resource "aws_security_group_rule" "jenkins_agent_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.jenkins_agent.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "jenkins_agent_ssh_from_bastion" {
  description = "jenkins agent host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.jenkins_agent.id
  source_security_group_id = local.bastion_service_security_group_id
}
