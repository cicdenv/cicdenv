resource "aws_subnet" "public" {
  for_each = toset(local.availability_zones)

  vpc_id = aws_vpc.me.id

  cidr_block = cidrsubnet(var.vpc_cidr_block, var.public_cidr_prefix_extension, index(local.availability_zones, each.key))

  availability_zone = each.key

  tags = merge(var.public_subnet_tags, map("Name", "${var.name}-public-${each.key}"))
}
