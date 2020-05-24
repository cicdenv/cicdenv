locals {
  cluster_name = var.cluster_name

  # kops/clusters/<cluster>/cluster/<workspace>
  master_asg_names = data.terraform_remote_state.cluster.outputs.master_autoscaling_group_ids

  # network/shared
  vpc_id            = data.terraform_remote_state.network.outputs.vpc.id
  public_subnet_ids = values(data.terraform_remote_state.network.outputs.subnets["public"]).*.id

  # kops/shared
  security_group   = data.terraform_remote_state.shared.outputs.security_groups.external_apiserver

  # kops/domains
  public_zone = data.terraform_remote_state.domains.outputs.kops_public_zone
}
