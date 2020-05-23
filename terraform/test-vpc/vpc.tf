module "test_vpc" {
  source = "../network/modules/custom-vpc"

  name = "test"

  vpc_cidr_block = var.network_cidr

  availability_zones = local.availability_zones
}

module "nat_gateways" {
  source = "../network/modules/nat-gateways"

  name = "test"

  availability_zones   = local.availability_zones
  public_subnets       = module.test_vpc.subnets["public"]
  private_route_tables = module.test_vpc.route_tables["private"]
}

module "vpc_endpoints" {
  source = "../network/modules/vpc-endpoints"

  name = "test"

  vpc_id = module.test_vpc.id

  public_route_tables  = module.test_vpc.route_tables["public"]
  private_route_tables = values(module.test_vpc.route_tables["private"]).*.id
  private_subnets      = values(module.test_vpc.subnets["private"]).*.id

  providers = {
    aws.main = aws.main
  }
}
