module "cluster" {
  source = "../cluster"

  terraform_settings = var.terraform_settings

  cluster_fqdn = local.cluster_fqdn

  folders = {
    working_dir = local.working_dir
    pki_folder  = local.pki_folder
  }

  input_files = {
    manifest   = module.manifest.manifest
    public_key = local.public_key
  }
  
  output_files = {
    ca_cert          = local.ca_cert
    admin_kubeconfig = local.admin_kubeconfig
    user_kubeconfig  = local.user_kubeconfig
  }
}
