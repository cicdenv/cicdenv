resource "aws_security_group" "test" {
  name   = "manual-test"
  vpc_id = module.test_vpc.vpc.id

  description = "manual testing"
}

resource "aws_security_group_rule" "test_egress" {
  description = "allow all outgoing traffic"

  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 0
  
  security_group_id = aws_security_group.test.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh_in" {
  description = "ssh access from allowed cidr blocks"

  protocol  = "tcp"
  type      = "ingress"
  from_port = 22
  to_port   = 22

  security_group_id = aws_security_group.test.id
  cidr_blocks       = local.cidr_blocks
}