locals {
  cluster_short_name = var.cluster_short_name
  cluster_name       = "${local.cluster_short_name}.kops.${var.domain}"

  state_store   = data.terraform_remote_state.backend.outputs.state_store
  state_key_arn = data.terraform_remote_state.backend.outputs.kops_state_key_arn

  etcd_key_arn = data.terraform_remote_state.shared.outputs.etcd_key_arn

  kubernetes_version = var.kubernetes_version
  
  network_cidr = data.terraform_remote_state.shared.outputs.cidr_block

  private_dns_zone = data.terraform_remote_state.shared.outputs.private_dns_zone

  availability_zones = data.terraform_remote_state.shared.outputs.availability_zones
  node_count         = var.node_count != -1 ? var.node_count : length(local.availability_zones) * 1
  
  master_instance_type = var.master_instance_type
  master_volume_size   = var.master_volume_size
  node_instance_type   = var.node_instance_type
  node_volume_size     = var.node_volume_size

  vpc_id             = data.terraform_remote_state.shared.outputs.vpc_id
  private_subnets    = data.terraform_remote_state.shared.outputs.private_subnet_ids
  public_subnets     = data.terraform_remote_state.shared.outputs.public_subnet_ids
  s3_vpc_endpoint_id = data.terraform_remote_state.shared.outputs.s3_vpc_endpoint_id

  masters_iam_role_name = data.terraform_remote_state.shared.outputs.masters_role_name
  nodes_iam_role_name   = data.terraform_remote_state.shared.outputs.nodes_role_name

  master_iam_profile = data.terraform_remote_state.shared.outputs.master_instance_profile_arn
  node_iam_profile   = data.terraform_remote_state.shared.outputs.nodes_instance_profile_arn

  master_security_groups = [data.terraform_remote_state.shared.outputs.masters_security_group_id]
  node_security_groups   = [data.terraform_remote_state.shared.outputs.nodes_security_group_id]

  internal_apiserver_security_groups = [data.terraform_remote_state.shared.outputs.internal_apiserver_security_group_id]
  
  public_key           = "~/.ssh/kops_rsa.pub"
  kops_ca_cert         = "${var.cluster_home}/cluster/${terraform.workspace}/kops.cacrt"
  kops_manifest        = "${var.cluster_home}/cluster/${terraform.workspace}/kops-manifest.yaml"
  admin_kubeconfig     = "${var.cluster_home}/cluster/${terraform.workspace}/kops-admin.kubeconfig"
  user_kubeconfig      = "${var.cluster_home}/cluster/${terraform.workspace}/kops-user.kubeconfig"
  authenticator_config = "${var.cluster_home}/cluster/${terraform.workspace}/kops-authenticator-configmap.yaml"

  working_dir = "${var.cluster_home}/cluster/${terraform.workspace}"  # kops update (terraform output)

  cloud_labels = var.cloud_labels
  
  admin_users = data.terraform_remote_state.iam_admins.outputs.admin_users

  admin_role = "${terraform.workspace == "main" ?
                  data.terraform_remote_state.iam_admins.outputs.terraform_role_arn
                : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${terraform.workspace}-admin"}"

  pki_folder = var.pki_folder
}
