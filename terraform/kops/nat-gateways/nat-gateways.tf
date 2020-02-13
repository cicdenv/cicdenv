module "nat_gateways" {
  source = "../../networking/modules/nat-gateways"

  name = "kops-clusters"

  availability_zones   = local.availability_zones
  public_subnets       = local.public_subnets
  private_route_tables = local.private_route_tables
}
