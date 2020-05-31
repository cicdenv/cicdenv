module "ecr_repo" {
  source = "../modules/ecr-repo"

  name = "pod-identity-webhook"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}
