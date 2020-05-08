module "kops_driver" {
  source = "../../../modules/kops-driver"

  region = var.region
  bucket = var.bucket
  domain = var.domain

  cluster_short_name = local.cluster_short_name

  kubernetes_version   = local.kubernetes_version
  master_instance_type = local.master_instance_type
  node_instance_type   = local.node_instance_type
  node_count           = local.node_count

  cluster_home = "${path.module}/.."
  
  pki_folder = "${path.module}/../../../backend/pki"
}
