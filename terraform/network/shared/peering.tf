resource "aws_vpc_peering_connection" "backend" {
  vpc_id = module.shared_vpc.vpc.id
  
  peer_vpc_id   = local.backend_vpc.id
  peer_owner_id = local.main_account.id
  peer_region   = var.region

  auto_accept   = false
}

resource "aws_vpc_peering_connection_accepter" "backend" {
  vpc_peering_connection_id = aws_vpc_peering_connection.backend.id
  
  auto_accept = true

  provider = aws.main
}

resource "aws_route" "to_backend" {
  for_each = module.shared_vpc.route_tables["private"]

  route_table_id            = each.value.id
  destination_cidr_block    = local.backend_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.backend.id
}

resource "aws_route" "to_shared" {
  for_each = local.backend_route_tables["private"]

  route_table_id            = each.value.id
  destination_cidr_block    = module.shared_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.backend.id

  provider = aws.main
}
