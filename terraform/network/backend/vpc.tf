module "vpc" {
  source = "../modules/custom-vpc"

  name = "backend.${var.domain}"

  domain = var.domain
  
  vpc_cidr_block = local.network_cidr

  availability_zones = values(local.availability_zones[local.region])
}
