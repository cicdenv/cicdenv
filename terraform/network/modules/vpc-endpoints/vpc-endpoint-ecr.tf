resource "aws_vpc_endpoint" "ecr" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.ecr.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.ecr_endpoint.id]

  subnet_ids = var.private_subnets

  private_dns_enabled = var.private_dns_enabled
}
