resource "aws_security_group" "kops_external_apiserver" {
  name   = "kops-external-apiserver"
  vpc_id = local.vpc_id

  description = "kops-apiserver external load balancer"
    
  tags = {
    Name = "kops-external-apiserver"
  }
}

resource "aws_security_group_rule" "kops_external_apiserver_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.kops_external_apiserver.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kops_external_apiserver_https" {
  count = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  
  description = "kops-apiserver external load balancer"

  type      = "ingress"
  protocol  = "tcp"
  from_port = 443
  to_port   = 443

  security_group_id = aws_security_group.kops_external_apiserver.id
  cidr_blocks       = var.allowed_cidr_blocks
}
