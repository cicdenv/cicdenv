module "kops_cluster" {
  source = "../kops-cluster"

  cluster_name = local.cluster_name
  state_store  = local.state_store

  kops_manifest = module.kops_manifest.kops_manifest

  public_key       = local.public_key
  kops_ca_cert     = local.kops_ca_cert
  admin_kubeconfig = local.admin_kubeconfig
  user_kubeconfig  = local.user_kubeconfig

  working_dir = local.working_dir
  
  pki_folder = local.pki_folder
}
