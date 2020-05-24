locals {
  kops_domain = data.terraform_remote_state.domains.outputs.kops_public_zone.domain

  cluster_name     = var.cluster_name
  cluster_instance = "${local.cluster_name}-${terraform.workspace}"
  cluster_fqdn     = "${local.cluster_instance}.${locals.kops_domain}"
  
  kubernetes_version = var.cluster_settings.kubernetes_version

  master_instance_type = var.cluster_settings.master_instance_type
  master_volume_size   = var.cluster_settings.master_volume_size
  node_instance_type   = var.cluster_settings.node_instance_type
  node_volume_size     = var.cluster_settings.node_volume_size  
  
  node_count = var.cluster_settings.node_count != -1 ? var.cluster_settings.node_count : length(local.availability_zones) * 1
  
  ami_id = var.ami_id

  public_key = "~/.ssh/kops_rsa.pub"

  home_folder = var.folders.home_folder  # For a single cluster-name:workspace (cluser-instance)
  # output files
  ca_cert              = "${local.home_folder}/cluster/${terraform.workspace}/kops.cacrt"
  manifest             = "${local.home_folder}/cluster/${terraform.workspace}/kops-manifest.yaml"
  admin_kubeconfig     = "${local.home_folder}/cluster/${terraform.workspace}/kops-admin.kubeconfig"
  user_kubeconfig      = "${local.home_folder}/cluster/${terraform.workspace}/kops-user.kubeconfig"
  authenticator_config = "${local.home_folder}/cluster/${terraform.workspace}/kops-authenticator-configmap.yaml"

  working_dir = "${local.home_folder}/cluster/${terraform.workspace}"  # kops update (terraform output)

  pki_folder = var.folders.pki_folder # terraform/kops/backend/pki

  # kops/backend
  state_store = data.terraform_remote_state.backend.outputs.state_store

  # kops/shared
  iam = data.terraform_remote_state.shared.outputs.iam
}
