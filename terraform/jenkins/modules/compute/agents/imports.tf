data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "jenkins_shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/jenkins_shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_organizations" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_organizations/terraform.tfstate"
    region = var.region
  }
}
