resource "aws_route_table" "private_routes" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.me.id

  tags = {
    Name = "${var.name}-private-rt-${local.availability_zones[count.index]}"
  }
}

resource "aws_route" "to_nat_gw" {
  count = length(local.availability_zones)

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = aws_route_table.private_routes.*.id[count.index]

  nat_gateway_id = aws_nat_gateway.nat_gw.*.id[count.index]
}

resource "aws_route_table_association" "private_route_net" {
  count = length(local.availability_zones)

  route_table_id = aws_route_table.private_routes.*.id[count.index]

  subnet_id = aws_subnet.private_subnets.*.id[count.index]
}
