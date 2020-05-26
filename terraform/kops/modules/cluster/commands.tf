module "kops_commands" {
  source = "../commands"

  terraform_state = var.terraform_state

  cluster_fqdn = local.cluster_fqdn

  files = {
    manifest         = local.manifest
    public_key       = local.public_key
    admin_kubeconfig = local.admin_kubeconfig
  }

  folders = {
    pki_folder = local.pki_folder
  }
}