module "ecr_repo" {
  source = "../modules/ecr-repo"

  name = "certificate-request-approver"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}
