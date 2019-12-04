resource "aws_subnet" "public_subnets" {
  count = length(local.availability_zones)

  vpc_id = aws_vpc.me.id

  cidr_block = cidrsubnet(var.vpc_cidr_block, var.public_cidr_prefix_extension, count.index)

  availability_zone = local.availability_zones[count.index]

  tags = merge(var.public_subnet_tags, map("Name", "${var.name}-public-subnet-${local.availability_zones[count.index]}"))
}
