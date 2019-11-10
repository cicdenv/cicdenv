module "api_server" {
  source = "../kops-apiserver-external-access"

  cluster_short_name = local.cluster_short_name

  vpc_id = local.vpc_id

  public_subnet_ids = local.public_subnet_ids

  master_asg_names            = local.master_asg_names
  apiserver_security_group_id = local.apiserver_security_group_id

  zone_id = local.zone_id

  providers = {
    aws.main = "aws.main"
  }
}
