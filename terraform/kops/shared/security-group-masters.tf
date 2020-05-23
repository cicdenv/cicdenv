resource "aws_security_group" "kops_masters" {
  name   = "kops-masters"
  vpc_id = local.vpc_id

  description = "kops-masters"

  tags = {
    Name = "kops-masters"
  }
}

resource "aws_security_group_rule" "kops_masters_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.kops_masters.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "kops_master_ssh_from_bastion" {
  description = "kops master host access via bastion service"

  type        = "ingress"
  protocol    = "tcp"
  from_port   = 22
  to_port     = 22

  security_group_id        = aws_security_group.kops_masters.id
  source_security_group_id = local.bastion.security_group.id
}

resource "aws_security_group_rule" "external-lb-https-to-master" {
  description = "external loadbalancer to master kube api-server"

  type      = "ingress"
  protocol  = "tcp"
  from_port = 443
  to_port   = 443

  security_group_id        = aws_security_group.kops_masters.id
  source_security_group_id = aws_security_group.kops_external_apiserver.id
}
