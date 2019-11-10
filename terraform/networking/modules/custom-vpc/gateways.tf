resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.me.id

  tags = {
    Name = "${var.name}-public-igw"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(local.availability_zones)

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "${var.name}-nat-gw-${local.availability_zones[count.index]}"
  }
}

resource "aws_eip" "nat_eip" {
  count = length(local.availability_zones)
  vpc   = true

  tags = {
    Name = "${var.name}-nat-gw-eip-${local.availability_zones[count.index]}"
  }
}
