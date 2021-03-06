data "terraform_remote_state" "network_shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
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

data "terraform_remote_state" "jenkins_routing" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/jenkins_routing/terraform.tfstate"
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
