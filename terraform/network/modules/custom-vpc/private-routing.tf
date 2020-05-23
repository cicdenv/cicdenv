resource "aws_route_table" "private" {
  for_each = toset(local.availability_zones)

  vpc_id = aws_vpc.me.id

  tags = {
    Name = "${var.name}-private-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each = toset(local.availability_zones)

  route_table_id = aws_route_table.private[each.key].id

  subnet_id = aws_subnet.private[each.key].id
}
