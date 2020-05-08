module "kops_external_access" {
  source = "../../../modules/kops-external-access"

  region = var.region
  bucket = var.bucket

  target_region = var.target_region

  cluster_short_name = var.cluster_short_name

  providers = {
    aws.main = aws.main
  }
}
