#
# VPC outputs
#

output "vpc_id" {
  value = aws_vpc.me.id
}

output "s3_vpc_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

#
# Public Subnet outputs
#

output "public_subnet_ids" {
  value = aws_subnet.public_subnets.*.id
}

output "public_subnet_azs" {
  value = aws_subnet.public_subnets.*.availability_zone
}

output "public_route_table_ids" {
  value = [aws_route_table.default.id]
}

#
# Private Subnet outputs
#

output "private_subnet_ids" {
  value = aws_subnet.private_subnets.*.id
}

output "private_subnet_azs" {
  value = aws_subnet.private_subnets.*.availability_zone
}

output "private_route_table_ids" {
  value = aws_route_table.private_routes.*.id
}
