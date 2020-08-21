output "transit_gateway_vpc_attachment" {
  value = {
    id                 = aws_ec2_transit_gateway_vpc_attachment.internet.id
    vpc_owner_id       = aws_ec2_transit_gateway_vpc_attachment.internet.vpc_owner_id
    transit_gateway_id = aws_ec2_transit_gateway_vpc_attachment.internet.transit_gateway_id
    vpc_id             = aws_ec2_transit_gateway_vpc_attachment.internet.vpc_id
    subnet_ids         = aws_ec2_transit_gateway_vpc_attachment.internet.subnet_ids
  }
}
