resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.me.id

  tags = {
    Name = var.name
  }
}
