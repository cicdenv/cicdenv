resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.me.id

  service_name = data.aws_vpc_endpoint_service.s3.service_name

  route_table_ids = flatten([
    aws_route_table.default.id,
    aws_route_table.private_routes.*.id
  ])
}

resource "aws_vpc_endpoint" "ecr" {
  vpc_id            = aws_vpc.me.id
  service_name      = data.aws_vpc_endpoint_service.ecr.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids  = [aws_security_group.ecr_endpoint.id]
  subnet_ids          = aws_subnet.private_subnets.*.id
  private_dns_enabled = true
}
