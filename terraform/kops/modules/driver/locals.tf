locals {
  # network
  availability_zones = data.terraform_remote_state.network_shared.outputs.availability_zones
  subnets            = data.terraform_remote_state.network_shared.outputs.subnets
  public_subnets     = local.subnets["public"]
  private_subnets    = local.subnets["private"]
  private_dns_zone   = data.terraform_remote_state.network_shared.outputs.private_dns_zone

  # ssh
  shared_ssh_key = data.terraform_remote_state.ssh.outputs.key_pairs.shared.public_key

  # iam/common-policies
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  # kops/backend
  state_store = data.terraform_remote_state.backend.outputs.state_store
  secrets     = data.terraform_remote_state.backend.outputs.secrets

  # kops/domains
  kops_domain = data.terraform_remote_state.domains.outputs.kops_public_zone.domain

  # kops/shared
  etcd_kms_key = data.terraform_remote_state.shared.outputs.etcd_kms_key
  
  # backend (accounts)
  account_admin = data.terraform_remote_state.accounts.outputs.organization_accounts[terraform.workspace].role

  # iam/users
  main_admin = data.terraform_remote_state.iam_users.outputs.iam.main_admin.role.arn

  cluster_name     = var.cluster_name
  cluster_instance = "${local.cluster_name}-${terraform.workspace}"
  cluster_fqdn     = "${local.cluster_instance}.${local.kops_domain}"
  
  kubernetes_version = var.cluster_settings.kubernetes_version

  master_instance_type = var.cluster_settings.master_instance_type
  master_volume_size   = var.cluster_settings.master_volume_size
  node_instance_type   = var.cluster_settings.node_instance_type
  node_volume_size     = var.cluster_settings.node_volume_size  
  
  nodes_per_az = var.cluster_settings.nodes_per_az
  
  ami_id = var.ami_id != "" ? var.ami_id : data.terraform_remote_state.amis.outputs.base_amis["ext4-ext4"].id

  ssh_key = "~/.ssh/id-shared-ec2-${terraform.workspace}.pub"

  home_folder = var.folders.home_folder  # For a single cluster-name:workspace (cluser-instance)
  # output files
  ca_cert              = "${local.home_folder}/cluster/${terraform.workspace}/kops.cacrt"
  manifest             = "${local.home_folder}/cluster/${terraform.workspace}/kops-manifest.yaml"
  admin_kubeconfig     = "${local.home_folder}/cluster/${terraform.workspace}/kops-admin.kubeconfig"
  user_kubeconfig      = "${local.home_folder}/cluster/${terraform.workspace}/kops-user.kubeconfig"
  authenticator_config = "${local.home_folder}/cluster/${terraform.workspace}/kops-authenticator-configmap.yaml"

  working_dir = "${local.home_folder}/cluster/${terraform.workspace}"  # kops update (terraform output)

  pki_folder = var.folders.pki_folder # terraform/kops/backend/pki

  admin_roles = terraform.workspace == "main" ? [local.main_admin] : [local.account_admin]
}
