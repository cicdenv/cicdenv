resource "aws_security_group" "redis_node" {
  name   = "redis-cluster-node"
  vpc_id = local.vpc.id

  description = "redis dedicated cluster node"
      
  tags = {
    Name = "redis-cluster-node"
  }
}

resource "aws_security_group_rule" "redis_node_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.redis_node.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "redis_node_ssh_from_bastion" {
  description = "redis cluster node host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.redis_node.id
  source_security_group_id = local.bastion_security_group.id
}

resource "aws_security_group_rule" "redis_node_clients" {
  description = "redis cluster client access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 6379
  to_port     = 6379 + (48 * 3)  # Support up to 72 hash bucket masters / 72 has bucket slaves

  security_group_id = aws_security_group.redis_node.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "redis_node_internal" {
  description = "redis cluster internal access"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 16379
  to_port     = 16379 + (48 * 3)  # Support up to 72 hash bucket masters / 72 has bucket slaves

  security_group_id        = aws_security_group.redis_node.id
  source_security_group_id = aws_security_group.redis_node.id
}
