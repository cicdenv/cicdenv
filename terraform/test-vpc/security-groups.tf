resource "aws_security_group" "test" {
  name   = "manual-test"
  vpc_id = module.vpc.vpc_id

  description = "manual testing"
}

resource "aws_security_group_rule" "test_egress" {
  security_group_id = aws_security_group.test.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh_in" {
  security_group_id = aws_security_group.test.id
  cidr_blocks       = local.cidr_blocks
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  type              = "ingress"
  description       = "ssh access from whitelisted cidr blocks"
}