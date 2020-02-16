data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops-shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "jenkins_shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/jenkins-shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_organizations" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam-organizations/terraform.tfstate"
    region = var.region
  }
}
