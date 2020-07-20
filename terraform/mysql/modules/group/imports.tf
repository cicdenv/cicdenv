data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/iam_common-policies/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/mysql_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}
