locals {
  # network/shared
  availability_zones = data.terraform_remote_state.network.outputs.availability_zones
  vpc_id             = data.terraform_remote_state.network.outputs.vpc.id
  network_cidr       = data.terraform_remote_state.network.outputs.vpc.cidr_block
  private_dns_zone   = data.terraform_remote_state.network.outputs.private_dns_zone
  subnets            = data.terraform_remote_state.network.outputs.subnets
  public_subnets     = local.subnets["public"]
  private_subnets    = local.subnets["private"]

  # kops/backend:
  state_store = data.terraform_remote_state.backend.outputs.state_store
  secrets     = data.terraform_remote_state.backend.outputs.secrets

  irsa_file_assets   = trimspace(data.terraform_remote_state.backend.outputs.irsa.cluster_spec["fileAssets"])
  irsa_kube_api_args = trimspace(data.terraform_remote_state.backend.outputs.irsa.cluster_spec["kubeAPIServer"])

  # kops/shared:
  etcd_kms_key           = data.terraform_remote_state.shared.outputs.etcd_kms_key
  master_security_groups = [data.terraform_remote_state.shared.outputs.security_groups.master.id]
  node_security_groups   = [data.terraform_remote_state.shared.outputs.security_groups.node.id]
  api_security_groups    = [data.terraform_remote_state.shared.outputs.security_groups.internal_apiserver.id]

  region = data.aws_region.current.name

  etcd_count = length(local.availability_zones) % 2 == 0 ? length(local.availability_zones) - 1 : length(local.availability_zones)
  etcd_zones = slice(local.availability_zones, 0, local.etcd_count)

  # kops-driver:
  cluster_fqdn = var.cluster_fqdn

  kubernetes_version = var.cluster_settings.kubernetes_version

  master_instance_type = var.cluster_settings.master_instance_type
  master_volume_size   = var.cluster_settings.master_volume_size
  node_instance_type   = var.cluster_settings.node_instance_type
  node_volume_size     = var.cluster_settings.node_volume_size
  nodes_per_az         = var.cluster_settings.nodes_per_az

  ami_id = var.ami_id
  
  iam = var.iam
  
  manifest = var.output_files.manifest

  networking = "canal"
}
