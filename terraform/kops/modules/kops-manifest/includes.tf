data "aws_region" "current" {}

data "aws_subnet" "private_subnets" {
  count = length(var.private_subnets)

  id = var.private_subnets[count.index]
}

data "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)

  id = var.public_subnets[count.index]
}
