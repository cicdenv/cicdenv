resource "aws_route_table" "default" {
  vpc_id = aws_vpc.me.id

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_main_route_table_association" "main_vpc_routes" {
  vpc_id = aws_vpc.me.id

  route_table_id = aws_route_table.default.id
}

resource "aws_route" "igw_route" {
  destination_cidr_block = "0.0.0.0/0"

  route_table_id = aws_route_table.default.id
  gateway_id     = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_route_net" {
  for_each = toset(local.availability_zones)

  route_table_id = aws_route_table.default.id
  subnet_id      = aws_subnet.public[each.key].id
}
