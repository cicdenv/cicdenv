resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.me.id

  service_name = data.aws_vpc_endpoint_service.s3.service_name

  route_table_ids = flatten([
    aws_route_table.default.id,
    values(aws_route_table.private).*.id,
  ])
}
