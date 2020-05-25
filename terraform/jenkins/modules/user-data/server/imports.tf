data "terraform_remote_state" "ecr_jenkins" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/shared_ecr-images_jenkins/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "jenkins_shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/jenkins_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "jenkins_backend" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/jenkins_backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "accounts" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}
