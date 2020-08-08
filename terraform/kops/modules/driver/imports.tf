data "terraform_remote_state" "network_shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "ssh" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/network_shared_ssh/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/kops_domains/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
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

data "terraform_remote_state" "iam_users" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/iam_users/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/iam_common-policies/terraform.tfstate"
    region = var.terraform_state.region
  }
}
