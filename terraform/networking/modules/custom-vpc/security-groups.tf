resource "aws_security_group" "ecr_endpoint" {
  name   = "ecr-endpoint"
  vpc_id = aws_vpc.me.id

  description = "ECR VPC Endpoint Interface SG"
      
  tags = {
    Name = "ecr-endpoint"
  }
}

resource "aws_security_group_rule" "ecr_endpoint_out" {
  security_group_id = aws_security_group.ecr_endpoint.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = -1
  from_port         = 0
  to_port           = 0
  description       = "ecr-endpoint egress"
}

resource "aws_security_group_rule" "ecr_endpoint_https" {
  security_group_id = aws_security_group.ecr_endpoint.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "docker registry access from hosts"
}
