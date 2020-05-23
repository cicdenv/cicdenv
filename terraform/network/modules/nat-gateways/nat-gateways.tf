resource "aws_nat_gateway" "nat_gw" {
  for_each = toset(var.availability_zones)

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = var.public_subnets[each.key].id

  tags = {
    Name = "${var.name}-${each.key}"
  }
}

resource "aws_eip" "nat_eip" {
  for_each = toset(var.availability_zones)

  vpc = true

  tags = {
    Name = "${var.name}-nat-gw-${each.key}"
  }
}
