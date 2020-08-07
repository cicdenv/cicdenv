resource "aws_security_group" "jenkins_persistent_config_efs" {
  name   = "jenkins-efs"
  vpc_id = local.vpc.id

  tags = {
    Name = "jenkins-servers persistent config efs"
  }
}

resource "aws_security_group_rule" "jenkins_persistent_config_efs_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.jenkins_persistent_config_efs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource aws_security_group_rule jenkins_persistent_config_efs_mount_targets_self {
  type      = "ingress"
  from_port = 2049
  to_port   = 2049
  protocol  = "tcp"

  security_group_id = aws_security_group.jenkins_persistent_config_efs.id
  self              = "true"
}

resource aws_security_group_rule jenkins_persistent_config_efs_mount_targets_jenkins_server {
  type      = "ingress"
  from_port = 2049
  to_port   = 2049
  protocol  = "tcp"

  security_group_id        = aws_security_group.jenkins_persistent_config_efs.id
  source_security_group_id = aws_security_group.jenkins_server.id
}
