module "cluster" {
  source = "../cluster"

  terraform_state = var.terraform_state

  cluster_fqdn = local.cluster_fqdn

  folders = {
    working_dir = local.working_dir
    pki_folder  = local.pki_folder
  }

  input_files = {
    manifest = module.manifest.manifest
    ssh_key  = local.ssh_key
    ca_cert  = local.ca_cert
  }
  
  output_files = {
    admin_kubeconfig = local.admin_kubeconfig
    user_kubeconfig  = local.user_kubeconfig
  }
}
