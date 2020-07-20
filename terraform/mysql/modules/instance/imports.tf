data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
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

data "terraform_remote_state" "mysql_shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/mysql_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "mysql_group_tls" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/mysql_groups_${var.name}_tls/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "mysql_group" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/mysql_groups_${var.name}/terraform.tfstate"
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
