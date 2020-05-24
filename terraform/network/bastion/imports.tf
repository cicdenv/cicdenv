data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
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

data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.region
  }
}
