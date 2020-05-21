data "terraform_remote_state" "iam_organizations" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_organizations/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "shared_domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_domains/terraform.tfstate"
    region = var.region
  }
}
