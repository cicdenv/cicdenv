resource "aws_vpc" "default" {
  cidr_block = var.default_vpc_cidr

  tags = {
    Name = "default"
  }
}

resource "aws_subnet" "default" {
  count = length(var.default_vpc_subnet_azs)
  
  vpc_id = aws_vpc.default.id

  availability_zone = var.default_vpc_subnet_azs[count.index]
  cidr_block = var.default_vpc_subnet_cidrs[count.index]

  map_public_ip_on_launch = "true"
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.default.default_network_acl_id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    to_port    = "0"
  }

  subnet_ids = aws_subnet.default.*.id
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.default.default_route_table_id
}

resource "aws_route" "default" {
  route_table_id            = aws_default_route_table.default.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.default.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.default.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
