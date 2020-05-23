resource "aws_route" "to_nat_gw" {
  for_each = toset(var.availability_zones)

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = var.private_route_tables[each.key].id

  nat_gateway_id = aws_nat_gateway.nat_gw[each.key].id
}
