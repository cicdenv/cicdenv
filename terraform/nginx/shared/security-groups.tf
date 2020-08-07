resource "aws_security_group" "nginx_node" {
  name   = "nginx-cluster-node"
  vpc_id = local.vpc.id

  description = "nginx dedicated cluster node"
      
  tags = {
    Name = "nginx-cluster-node"
  }
}

resource "aws_security_group_rule" "nginx_node_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.nginx_node.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nginx_node_ssh_from_bastion" {
  description = "nginx cluster node host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.nginx_node.id
  source_security_group_id = local.bastion_security_group.id
}

resource "aws_security_group_rule" "nginx_node_clients" {
  description = "nginx cluster client access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443

  security_group_id = aws_security_group.nginx_node.id
  cidr_blocks       = ["0.0.0.0/0"]
}
