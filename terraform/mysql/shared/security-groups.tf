resource "aws_security_group" "mysql_shared" {
  name   = "mysql-shared"
  vpc_id = local.vpc.id

  description = "mysql common"
      
  tags = {
    Name = "mysql-shared"
  }
}

resource "aws_security_group_rule" "mysql_shared_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.mysql_shared.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mysql_shared_ssh_from_bastion" {
  description = "mysql host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.mysql_shared.id
  source_security_group_id = local.bastion_security_group.id
}
