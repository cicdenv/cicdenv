locals {
  # shared:
  state_store = data.terraform_remote_state.backend.outputs.state_store

  region = data.aws_region.current.name

  cluster_fqdn = var.cluster_fqdn

  # input files
  public_key = var.input_files.public_key
  manifest   = var.input_files.manifest

  # output files
  ca_cert = var.output_files.ca_cert
  fetched = {
    ca_cert = data.null_data_source.wait_for_ca_cert_fetch.outputs["ca_cert"]
  }
  admin_kubeconfig = var.output_files.admin_kubeconfig
  user_kubeconfig  = var.output_files.user_kubeconfig

  # folders
  working_dir = var.folders.working_dir
  pki_folder  = var.folders.pki_folder
}
