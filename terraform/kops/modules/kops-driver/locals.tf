locals {
  cluster_short_name = var.cluster_short_name
  cluster_name       = "${local.cluster_short_name}.kops.${var.domain}"

  state_store   = data.terraform_remote_state.backend.outputs.state_store
  state_key_arn = data.terraform_remote_state.backend.outputs.kops_state_key_arn

  etcd_kms_key = data.terraform_remote_state.shared.outputs.etcd_kms_key

  kubernetes_version = var.kubernetes_version
  
  network_cidr = data.terraform_remote_state.network.outputs.vpc.cidr_block

  private_dns_zone = data.terraform_remote_state.network.outputs.private_dns_zone

  availability_zones = data.terraform_remote_state.network.outputs.availability_zones
  node_count         = var.node_count != -1 ? var.node_count : length(local.availability_zones) * 1
  
  master_instance_type = var.master_instance_type
  master_volume_size   = var.master_volume_size
  node_instance_type   = var.node_instance_type
  node_volume_size     = var.node_volume_size

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  subnets             = data.terraform_remote_state.network.outputs.subnets
  public_subnets_ids  = values(local.subnets["public"]).*.id
  private_subnets_ids = values(local.subnets["private"]).*.id

  iam = data.terraform_remote_state.shared.outputs.iam

  master_security_groups = [data.terraform_remote_state.shared.outputs.security_groups.master.id]
  node_security_groups   = [data.terraform_remote_state.shared.outputs.security_groups.node.id]

  internal_apiserver_security_groups = [data.terraform_remote_state.shared.outputs.security_groups.internal_apiserver.id]
  
  public_key           = "~/.ssh/kops_rsa.pub"
  kops_ca_cert         = "${var.cluster_home}/cluster/${terraform.workspace}/kops.cacrt"
  kops_manifest        = "${var.cluster_home}/cluster/${terraform.workspace}/kops-manifest.yaml"
  admin_kubeconfig     = "${var.cluster_home}/cluster/${terraform.workspace}/kops-admin.kubeconfig"
  user_kubeconfig      = "${var.cluster_home}/cluster/${terraform.workspace}/kops-user.kubeconfig"
  authenticator_config = "${var.cluster_home}/cluster/${terraform.workspace}/kops-authenticator-configmap.yaml"

  working_dir = "${var.cluster_home}/cluster/${terraform.workspace}"  # kops update (terraform output)

  cloud_labels = var.cloud_labels
  
  admin_users = data.terraform_remote_state.iam_users.outputs.admins

  admin_role = "${terraform.workspace == "main" ?
                  data.terraform_remote_state.iam_users.outputs.main_admin_role.arn
                : data.terraform_remote_state.accounts.outputs.organization_accounts[terraform.workspace].role

  pki_folder = var.pki_folder
}
