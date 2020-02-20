#
# https://docs.aws.amazon.com/fsx/latest/LustreGuide/limit-access-security-groups.html
#
# tcp:988 ingress self
# tcp:988 ingress servers / agents
#

resource "aws_security_group" "jenkins_fsx" {
  name   = "jenkins-fsx"
  vpc_id = local.vpc_id

  tags = {
    Name = "jenkins fast build storage"
  }
}

resource "aws_security_group_rule" "jenkins_fsx_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.jenkins_fsx.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource aws_security_group_rule jenkins_fsx_self {
  type      = "ingress"
  from_port = 988
  to_port   = 988
  protocol  = "tcp"

  security_group_id = aws_security_group.jenkins_fsx.id
  self              = "true"
}

resource aws_security_group_rule jenkins_fsx_jenkins_server {
  type      = "ingress"
  from_port = 988
  to_port   = 988
  protocol  = "tcp"

  security_group_id        = aws_security_group.jenkins_fsx.id
  source_security_group_id = aws_security_group.jenkins_server.id
}

resource aws_security_group_rule jenkins_fsx_jenkins_agent {
  type      = "ingress"
  from_port = 988
  to_port   = 988
  protocol  = "tcp"

  security_group_id        = aws_security_group.jenkins_fsx.id
  source_security_group_id = aws_security_group.jenkins_agent.id
}
