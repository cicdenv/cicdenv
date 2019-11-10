module "kops_commands" {
  source = "../kops-commands"

  cluster_name = var.cluster_name
  state_store  = var.state_store

  kops_manifest = var.kops_manifest

  public_key        = var.public_key
  admin_kubeconfig  = var.admin_kubeconfig

  pki_folder = var.pki_folder
}
