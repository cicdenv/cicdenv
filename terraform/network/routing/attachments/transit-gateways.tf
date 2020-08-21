resource "aws_ec2_transit_gateway_vpc_attachment" "internet" {
  subnet_ids         = values(local.shared_vpc.subnets["private"]).*.id
  transit_gateway_id = local.transit_gateway.id
  vpc_id             = local.shared_vpc.vpc.id
}

resource "aws_route" "default" {
  for_each = local.shared_vpc.route_tables["private"]

  destination_cidr_block = "0.0.0.0/0"

  route_table_id = each.value.id
  
  transit_gateway_id = local.transit_gateway.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.internet,
  ]
}

resource "aws_route" "backend_public_to_shared" {
  for_each = toset(local.backend_route_tables["public"])

  destination_cidr_block = local.shared_vpc.vpc.cidr_block

  route_table_id = each.key

  transit_gateway_id = local.transit_gateway.id

  provider = aws.main

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.internet,
  ]
}
