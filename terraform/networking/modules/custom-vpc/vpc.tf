resource "aws_vpc" "me" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames = true
  
  tags = {
    Name = var.name
  }
}
