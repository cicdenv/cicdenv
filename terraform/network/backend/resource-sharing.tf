resource "aws_ram_resource_share" "internet" {
  name = "internet-access"
  
  allow_external_principals = false

  tags = {
    Name = "Internet Access"
  }
}

resource "aws_ram_resource_association" "internet" {
  resource_share_arn = aws_ram_resource_share.internet.arn
  resource_arn       = aws_ec2_transit_gateway.internet.arn
}

resource "aws_ram_principal_association" "internet" {
  resource_share_arn = aws_ram_resource_share.internet.arn

  principal = local.organization.arn
}
