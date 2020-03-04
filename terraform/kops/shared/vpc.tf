module "vpc" {
  source = "../../networking/modules/custom-vpc"

  name = "kops-clusters"

  vpc_cidr_block = local.network_cidr

  availability_zones = local.availability_zones

  public_subnet_tags  = merge(local.cluster_tags, local.public_subnet_tags)
  private_subnet_tags = merge(local.cluster_tags, local.private_subnet_tags)

  providers = {
    aws.main = aws.main
  }
}
