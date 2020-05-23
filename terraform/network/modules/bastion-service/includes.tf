data "aws_subnet" "public_subnets" {
  count = length(var.public_subnets)
  id    = var.public_subnets[count.index]
}
