module "ecr_repo" {
  source = "../modules/ecr-repo"

  name = "nginx-plus"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}
