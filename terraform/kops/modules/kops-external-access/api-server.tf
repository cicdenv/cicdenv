module "api_server" {
  source = "../kops-apiserver-external-access"

  cluster_short_name = local.cluster_short_name

  vpc_id = local.vpc_id

  public_subnet_ids = local.public_subnets_ids

  master_asg_names  = local.master_asg_names
  security_group_id = local.security_group.id

  zone_id = local.kops_public_zone.zone_id

  providers = {
    aws.main = aws.main
  }
}
