module "kops_manifest" {
  source = "../kops-manifest"

  cluster_short_name = local.cluster_short_name
  cluster_name       = local.cluster_name
  state_store        = local.state_store

  kubernetes_version = local.kubernetes_version

  vpc_id             = local.vpc_id
  network_cidr       = local.network_cidr
  private_dns_zone   = local.private_dns_zone

  private_subnets    = local.private_subnets
  public_subnets     = local.public_subnets
  availability_zones = local.availability_zones

  node_count           = local.node_count
  node_instance_type   = local.node_instance_type
  node_volume_size     = local.node_volume_size
  master_instance_type = local.master_instance_type
  master_volume_size   = local.master_volume_size
  ami                  = local.ami

  cloud_labels = local.cloud_labels

  master_iam_profile = local.master_iam_profile
  node_iam_profile   = local.node_iam_profile

  master_security_groups = local.master_security_groups
  node_security_groups   = local.node_security_groups

  internal_apiserver_security_groups = local.internal_apiserver_security_groups

  kops_manifest = local.kops_manifest

  etcd_key_arn = local.etcd_key_arn
}
