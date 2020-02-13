resource "aws_route" "to_nat_gw" {
  count = length(var.private_route_tables)

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = var.private_route_tables[count.index]

  nat_gateway_id = aws_nat_gateway.nat_gw.*.id[count.index]
}
