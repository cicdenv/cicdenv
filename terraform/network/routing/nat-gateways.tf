module "nat_gateways" {
  source = "../modules/nat-gateways"

  name = "shared"

  public_subnets       = local.subnets["public"]
  private_route_tables = local.route_tables["private"]
  
  availability_zones = local.availability_zones
}
