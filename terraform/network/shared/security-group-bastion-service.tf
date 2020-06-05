resource "aws_security_group" "bastion" {
  name   = "bastion-service"
  vpc_id = module.shared_vpc.vpc.id

  description = "Bastion service"
      
  tags = {
    Name = "bastion-service"
  }
}

resource "aws_security_group_rule" "bastion_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "bastion_service_in" {
  description = "bastion service ssh access from outside"

  type      = "ingress"
  protocol  = "tcp"
  from_port = var.ssh_service_port
  to_port   = var.ssh_service_port

  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = var.whitelisted_cidr_blocks
}

resource "aws_security_group_rule" "bastion_service_healthcheck" {
  description = "bastion service ssh access from NLB"

  type      = "ingress"
  protocol  = "tcp"
  from_port = var.ssh_service_port + 1
  to_port   = var.ssh_service_port + 1

  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = [module.shared_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "bastion_host_in" {
  description = "bastion host ssh access from outside"

  type      = "ingress"
  protocol  = "tcp"
  from_port = var.ssh_host_port
  to_port   = var.ssh_host_port

  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = var.whitelisted_cidr_blocks
}

resource "aws_security_group_rule" "bastion_host_healthcheck" {
  description = "bastion host ssh access from NLB"

  type      = "ingress"
  protocol  = "tcp"
  from_port = var.ssh_host_port
  to_port   = var.ssh_host_port

  security_group_id = aws_security_group.bastion.id
  cidr_blocks       = [module.shared_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "events_host_in" {
  description = "bastion host sns access from vpc-e"

  type      = "ingress"
  protocol  = "tcp"
  from_port = var.iam_event_port
  to_port   = var.iam_event_port

  security_group_id        = aws_security_group.bastion.id
  source_security_group_id = aws_security_group.events.id
}
