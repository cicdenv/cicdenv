data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/iam_common-policies/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_assumed_roles" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_assumed-roles/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_events" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_events/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr_bastion_sshd_worker" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_bastion-sshd-worker/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr_bastion_events_worker" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_bastion-events-worker/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_backend/terraform.tfstate"
    region = var.region
  }
}
