module "ecr_repo" {
  source = "../modules/ecr-repo"

  name = "certificate-init-container"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}
