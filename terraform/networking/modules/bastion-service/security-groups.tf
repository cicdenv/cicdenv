resource "aws_security_group" "bastion" {
  name   = "bastion"
  vpc_id = var.vpc_id

  description = "Bastion service"
      
  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group_rule" "bastion_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "bastion egress"
}

resource "aws_security_group_rule" "service_in" {
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = local.cidr_blocks
  from_port         = var.service_ssh_port
  to_port           = var.service_ssh_port
  protocol          = "tcp"
  type              = "ingress"
  description       = "service ssh access from outside"
}

resource "aws_security_group_rule" "host_in" {
  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = local.cidr_blocks
  from_port         = var.host_ssh_port
  to_port           = var.host_ssh_port
  protocol          = "tcp"
  type              = "ingress"
  description       = "host ssh access from outside"
}

resource "aws_security_group_rule" "ssh_from_bastion" {
  count = length(var.security_groups)

  security_group_id        = var.security_groups[count.index]
  source_security_group_id = aws_security_group.bastion.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  type        = "ingress"
  description = "access to hosts"
}