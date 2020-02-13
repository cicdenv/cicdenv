resource "aws_route_table" "private_routes" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.me.id

  tags = {
    Name = "${var.name}-private-rt-${local.availability_zones[count.index]}"
  }
}

resource "aws_route_table_association" "private_route_net" {
  count = length(local.availability_zones)

  route_table_id = aws_route_table.private_routes.*.id[count.index]

  subnet_id = aws_subnet.private_subnets.*.id[count.index]
}
