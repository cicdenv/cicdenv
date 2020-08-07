resource "aws_security_group" "kops_nodes" {
  name   = "kops-nodes"
  vpc_id = local.vpc.id

  description = "kops-nodes"

  tags = {
    Name = "kops-nodes"
  }
}

resource "aws_security_group_rule" "kops_nodes_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.kops_nodes.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kops_node_ssh_from_bastion" {
  description = "kops node host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.kops_nodes.id
  source_security_group_id = local.bastion.security_group.id
}
