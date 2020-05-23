resource "aws_subnet" "private" {
  for_each = toset(local.availability_zones)

  vpc_id = aws_vpc.me.id

  cidr_block = cidrsubnet(var.vpc_cidr_block, var.private_cidr_prefix_extension, var.private_cidr_offset + index(local.availability_zones, each.key))

  availability_zone = each.key

  tags = merge(var.private_subnet_tags, map("Name", "${var.name}-private-${each.key}"))
}
