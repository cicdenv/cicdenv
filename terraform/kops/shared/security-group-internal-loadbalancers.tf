resource "aws_security_group" "kops_internal_apiserver" {
  name   = "kops-internal-apiserver"
  vpc_id = module.vpc.vpc_id

  description = "kops-apiserver internal load balancer"
    
  tags = {
    Name = "kops-internal-apiserver"
  }
}

resource "aws_security_group_rule" "kops_internal_apiserver_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.kops_internal_apiserver.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kops_internal_apiserver_icmp-pmtu" {
  description = "internal loadbalancer icmp path mtu discovery traffic"

  type      = "ingress"
  protocol  = "icmp"
  from_port = 3
  to_port   = 4

  security_group_id = aws_security_group.kops_internal_apiserver.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kops_internal_apiserver_https" {
  description = "kops-apiserver internal loadbalancer vpc access"

  type       = "ingress"
  protocol   = "tcp"
  from_port  = 443
  to_port    = 443

  security_group_id = aws_security_group.kops_internal_apiserver.id
  cidr_blocks       = ["0.0.0.0/0"]
}
