module "vpc" {
  source = "../networking/modules/custom-vpc"

  name = "manual testing"

  vpc_cidr_block = var.network_cidr

  availability_zones = local.availability_zones

  providers = {
    aws.main = aws.main
  }
}
