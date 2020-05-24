locals {
  region = data.aws_region.current.name

  availability_zones = data.terraform_remote_state.network.outputs.availability_zones
  etcd_zones = length(local.availability_zones) % 2 == 0 ? length(local.availability_zones) - 1 : length(local.availability_zones)

  # network
  vpc_id           = data.terraform_remote_state.network.outputs.vpc.id
  network_cidr     = data.terraform_remote_state.network.outputs.vpc.cidr_block
  private_dns_zone = data.terraform_remote_state.network.outputs.private_dns_zone
  subnets          = data.terraform_remote_state.network.outputs.subnets
  public_subnets   = local.subnets["public"]
  private_subnets  = local.subnets["private"]

  # shared:
  state_store            = data.terraform_remote_state.backend.outputs.state_store
  etcd_kms_key           = data.terraform_remote_state.shared.outputs.etcd_kms_key
  master_security_groups = [data.terraform_remote_state.shared.outputs.security_groups.master.id]
  node_security_groups   = [data.terraform_remote_state.shared.outputs.security_groups.node.id]
  api_security_groups    = [data.terraform_remote_state.shared.outputs.security_groups.internal_apiserver.id]
  iam                    = data.terraform_remote_state.shared.outputs.iam

  # kops-driver:
  cluster_name = var.cluster_name

  kubernetes_version = var.cluster_settings.kubernetes_version

  master_instance_type = var.cluster_settings.master_instance_type
  master_volume_size   = var.cluster_settings.master_volume_size
  node_instance_type   = var.cluster_settings.node_instance_type
  node_volume_size     = var.cluster_settings.node_volume_size  
  
  node_count = var.cluster_settings.node_count != -1 ? var.cluster_settings.node_count : length(local.availability_zones) * 1
  node_per_az = ceil(local.node_count / length(local.availability_zones))
  node_counts = map(flatten([for az in local.availability_zones : list(az, local.node_per_az)]))

  ami_id = var.ami_id

  manifest = var.manifest

  # Must match kops/modules/kops-addons/kube2iam::host_interface
  networking = "canal"
}
