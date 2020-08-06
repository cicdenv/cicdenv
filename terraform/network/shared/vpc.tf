module "shared_vpc" {
  source = "../modules/custom-vpc"

  name = "shared-${terraform.workspace}.${var.domain}"

  domain = var.domain
  
  vpc_cidr_block = local.network_cidr

  public_subnet_tags  = merge(local.cluster_tags, local.public_subnet_tags)
  private_subnet_tags = merge(local.cluster_tags, local.private_subnet_tags)

  availability_zones = local.availability_zones
}
