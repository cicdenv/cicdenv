module "manifest" {
  source = "../manifest"

  # pass thru from terraform/kops/bin/kops.inc
  terraform_state  = var.terraform_state
  cluster_settings = var.cluster_settings
  ami_id           = var.ami_id
  
  cluster_fqdn       = local.cluster_fqdn

  output_files = {
    manifest = local.manifest
  }
}
