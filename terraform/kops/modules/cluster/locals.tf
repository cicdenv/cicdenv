locals {
  # shared:
  state_store = data.terraform_remote_state.backend.outputs.state_store

  region = data.aws_region.current.name

  cluster_fqdn = var.cluster_fqdn

  # input files
  ssh_key  = var.input_files.ssh_key
  manifest = var.input_files.manifest
  ca_cert  = var.input_files.ca_cert

  # output files
  admin_kubeconfig = var.output_files.admin_kubeconfig
  user_kubeconfig  = var.output_files.user_kubeconfig

  # folders
  working_dir = var.folders.working_dir
  pki_folder  = var.folders.pki_folder
}
