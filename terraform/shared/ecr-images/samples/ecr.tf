module "ecr_repo" {
  source = "../modules/ecr-repo"

  name = "samples"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}
