data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/iam-common-policies/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr_bastion_sshd_worker" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared-ecr-images-bastion-sshd-worker/terraform.tfstate"
    region = var.region
  }
}
