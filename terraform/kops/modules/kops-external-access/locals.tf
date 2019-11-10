locals {
  cluster_short_name = var.cluster_short_name
  cluster_name       = data.terraform_remote_state.cluster_config.outputs.cluster_name

  vpc_id = data.terraform_remote_state.shared.outputs.vpc_id

  public_subnet_ids = data.terraform_remote_state.shared.outputs.public_subnet_ids

  master_asg_names            = data.terraform_remote_state.cluster.outputs.master_autoscaling_group_ids
  apiserver_security_group_id = data.terraform_remote_state.shared.outputs.external_apiserver_security_group_id

  zone_id = data.terraform_remote_state.domains.outputs.kops_public_zone_id
}
