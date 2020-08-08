module "vpc_endpoints" {
  source = "../modules/vpc-endpoints"

  name = "backend"

  vpc_id = local.vpc.id

  private_subnets = values(local.subnets["private"]).*.id

  private_dns_enabled = false
}
