data "terraform_remote_state" "iam_assumed_roles" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam-assumed-roles/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "apt_repo" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared-apt-repo/terraform.tfstate"
    region = var.region
  }
}
