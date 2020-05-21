data "terraform_remote_state" "iam_organizations" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_organizations/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_common-policies/terraform.tfstate"
    region = var.region
  }
}
