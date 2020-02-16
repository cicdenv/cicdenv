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

data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.region
  }
}
