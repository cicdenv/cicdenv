data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops_domains/terraform.tfstate"
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

data "terraform_remote_state" "iam_assumed_roles" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_assumed-roles/terraform.tfstate"
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

data "terraform_remote_state" "iam_events" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_events/terraform.tfstate"
    region = var.region
  }
}
