module "ecr_repo" {
  source = "../modules/ecr-repo"

  name = "bastion-sshd-worker"

  terraform_state = {
    region = var.region
    bucket = var.bucket
  }
}
