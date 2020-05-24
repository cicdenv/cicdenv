module "addons" {
  source = "../addons"

  terraform_settings = var.terraform_settings

  cluster_fqdn = local.cluster_fqdn
  
  output_files = {
    authenticator_config = local.authenticator_config
  }
}
