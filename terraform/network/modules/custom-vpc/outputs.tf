#
# VPC outputs
#

output "vpc" {
  value = {
    id         = aws_vpc.me.id
    arn        = aws_vpc.me.arn
    cidr_block = aws_vpc.me.cidr_block
  }
}

output "private_dns_zone" {
  value = {
    name         = aws_route53_zone.private.name
    zone_id      = aws_route53_zone.private.zone_id
    name_servers = aws_route53_zone.private.name_servers

    # .name with trailing dot stripped
    domain       = replace(aws_route53_zone.private.name, "/\\.$/", "")
  }
}

output "subnets" {
  value = {
    public = {for az, subnet in aws_subnet.public : az => {
      id         = subnet.id
      arn        = subnet.arn
      cidr_block = subnet.cidr_block
    }}
    private = {for az, subnet in aws_subnet.private : az => {
      id         = subnet.id
      arn        = subnet.arn
      cidr_block = subnet.cidr_block
    }}
  }
}

output "route_tables" {
  value = {
    public = [aws_route_table.default.id]
    private = {for az, route_table in aws_route_table.private : az => {
      id = route_table.id
    }}
  }
}
