resource "aws_ec2_transit_gateway" "internet" {
  description = "Internet Access"

  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
}
