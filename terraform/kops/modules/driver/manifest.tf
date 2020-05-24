module "manifest" {
  source = "../manifest"

  # pass thru from terraform/kops/bin/kops.inc
  terraform_settings = var.terraform_settings
  cluster_name       = var.cluster_name
  cluster_settings   = var.cluster_settings
  ami_id             = var.ami_id

  output_files = {
    manifest = local.manifest
  }
}
