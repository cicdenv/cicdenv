resource "aws_security_group" "wireguard" {
  name   = "wireguard"
  vpc_id = local.vpc.id

  description = "Wireguard"
      
  tags = {
    Name = "wireguard"
  }
}

resource "aws_security_group_rule" "wireguard_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.wireguard.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "wireguard_server_ssh_from_bastion" {
  description = "wireguard server host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.wireguard.id
  source_security_group_id = local.bastion_security_group.id
}

resource "aws_security_group_rule" "wireguard_in" {
  description = "wireguard udp access from outside"

  type      = "ingress"
  protocol  = "udp"
  from_port = 51820
  to_port   = 51820

  security_group_id = aws_security_group.wireguard.id
  cidr_blocks       = ["0.0.0.0/0"]  # Unrestricted access thru public NLB
}

resource "aws_security_group_rule" "wireguard_healthcheck" {
  description = "health check tcp access from NLB"

  type      = "ingress"
  protocol  = "tcp"
  from_port = 22
  to_port   = 22

  security_group_id = aws_security_group.wireguard.id
  cidr_blocks       = [local.vpc.cidr_block]
}
