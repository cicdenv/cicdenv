resource "aws_ec2_transit_gateway_vpc_attachment" "internet" {
  subnet_ids         = values(module.shared_vpc.subnets["private"]).*.id
  transit_gateway_id = local.transit_gateway.id
  vpc_id             = module.shared_vpc.vpc.id
}
