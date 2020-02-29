resource "aws_security_group" "ecr_endpoint" {
  name   = "ecr-endpoint"
  vpc_id = aws_vpc.me.id

  description = "ECR VPC Endpoint Interface SG"
      
  tags = {
    Name = "ecr-endpoint"
  }
}

resource "aws_security_group_rule" "ecr_endpoint_out" {
  description = "allow all outgoing traffic"

  type      = "egress"
  protocol  = "all"
  from_port = 0
  to_port   = 0

  security_group_id = aws_security_group.ecr_endpoint.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecr_endpoint_https" {
  description = "docker registry access from hosts"

  type      = "ingress"
  protocol  = "tcp"
  from_port = 443
  to_port   = 443

  security_group_id = aws_security_group.ecr_endpoint.id
  cidr_blocks       = ["0.0.0.0/0"]
}
