resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block = "0.0.0.0/0"

  transit_gateway_route_table_id = local.transit_gateway.default.route_tables["association"].id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.internet.id
}
