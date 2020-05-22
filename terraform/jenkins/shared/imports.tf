data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/iam_common-policies/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr_jenkins" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_jenkins/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "jenkins_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/jenkins_backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "accounts" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/backend/terraform.tfstate"
    region = var.region
  }
}
