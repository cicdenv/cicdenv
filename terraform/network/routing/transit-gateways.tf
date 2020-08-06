resource "aws_ec2_transit_gateway_vpc_attachment" "internet" {
  subnet_ids         = values(local.subnets["private"]).*.id
  transit_gateway_id = local.transit_gateway.id
  vpc_id             = local.vpc.id
}
