module "vpc_endpoints" {
  source = "../modules/vpc-endpoints"

  name = "shared"

  vpc_id = local.vpc_id

  public_route_tables  = local.route_tables["public"]
  private_route_tables = values(local.route_tables["private"]).*.id
  private_subnets      = values(local.subnets["private"]).*.id

  providers = {
    aws.main = aws.main
  }
}
