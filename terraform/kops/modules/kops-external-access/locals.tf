locals {
  cluster_short_name = var.cluster_short_name
  cluster_name       = data.terraform_remote_state.cluster_config.outputs.cluster_name

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  public_subnet_ids = values(data.terraform_remote_state.network.outputs.subnets["public"]).*.id

  master_asg_names = data.terraform_remote_state.cluster.outputs.master_autoscaling_group_ids
  security_group   = security_groups.external_apiserver

  kops_public_zone = data.terraform_remote_state.domains.outputs.kops_public_zone
}
