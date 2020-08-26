data "terraform_remote_state" "accounts" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "apt_repo" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_apt-repo/terraform.tfstate"
    region = var.region
  }
}
