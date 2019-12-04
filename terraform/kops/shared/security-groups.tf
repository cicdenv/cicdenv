#
# KOPS masters
#
resource "aws_security_group" "kops_masters" {
  name   = "kops-masters"
  vpc_id = module.vpc.vpc_id

  description = "kops-masters"

  tags = {
    Name = "kops-masters"
  }
}

resource "aws_security_group_rule" "kops_masters_egress" {
  security_group_id = aws_security_group.kops_masters.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

#
# KOPS nodes
#
resource "aws_security_group" "kops_nodes" {
  name   = "kops-nodes"
  vpc_id = module.vpc.vpc_id

  description = "kops-nodes"

  tags = {
    Name = "kops-nodes"
  }
}

resource "aws_security_group_rule" "kops_nodes_egress" {
  security_group_id = aws_security_group.kops_nodes.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

#
# KOPS internal api-server
#
resource "aws_security_group" "kops_internal_apiserver" {
  name   = "kops-internal-apiserver"
  vpc_id = module.vpc.vpc_id

  description = "kops-apiserver internal load balancer"
    
  tags = {
    Name = "kops-internal-apiserver"
  }
}

resource "aws_security_group_rule" "kops_internal_apiserver_icmp-pmtu" {
  type              = "ingress"
  security_group_id = aws_security_group.kops_internal_apiserver.id
  from_port         = 3
  to_port           = 4
  protocol          = "icmp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kops_internal_apiserver_https" {
  count = length(var.whitelisted_cidr_blocks) > 0 ? 1 : 0

  type                     = "ingress"
  security_group_id        = aws_security_group.kops_internal_apiserver.id
  cidr_blocks              = ["0.0.0.0/0"]
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "kops_internal_apiserver_egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.kops_internal_apiserver.id
  cidr_blocks              = ["0.0.0.0/0"]
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

#
# KOPS external api-server
#
resource "aws_security_group" "kops_external_apiserver" {
  name   = "kops-external-apiserver"
  vpc_id = module.vpc.vpc_id

  description = "kops-apiserver external load balancer"
    
  tags = {
    Name = "kops-external-apiserver"
  }
}

resource "aws_security_group_rule" "kops_external_apiserver_https" {
  count = length(var.whitelisted_cidr_blocks) > 0 ? 1 : 0

  type                     = "ingress"
  security_group_id        = aws_security_group.kops_external_apiserver.id
  cidr_blocks              = var.whitelisted_cidr_blocks
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "kops_external_apiserver_egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.kops_external_apiserver.id
  cidr_blocks              = ["0.0.0.0/0"]
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
}

# Open KOPS external-api-server to master nodes
resource "aws_security_group_rule" "https-elb-to-master" {
  type                     = "ingress"
  security_group_id        = aws_security_group.kops_masters.id
  source_security_group_id = aws_security_group.kops_external_apiserver.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
}
