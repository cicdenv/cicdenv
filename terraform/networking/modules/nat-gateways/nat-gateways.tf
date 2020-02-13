resource "aws_nat_gateway" "nat_gw" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.public_subnets[count.index]

  tags = {
    Name = "${var.name}-nat-gw-${var.availability_zones[count.index]}"
  }
}

resource "aws_eip" "nat_eip" {
  count = length(var.availability_zones)
  vpc   = true

  tags = {
    Name = "${var.name}-nat-gw-eip-${var.availability_zones[count.index]}"
  }
}
