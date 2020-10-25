module "addons" {
  source = "../addons"

  terraform_state = var.terraform_state

  cluster_fqdn = local.cluster_fqdn
  
  admin_roles = local.admin_roles
  
  input_files = {
    ca_cert = local.ca_cert
  }

  output_files = {
    authenticator_config = local.authenticator_config
  }
}
