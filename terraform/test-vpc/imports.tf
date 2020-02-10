data "terraform_remote_state" "iam_assumed_roles" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam-assumed-roles/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/iam-common-policies/terraform.tfstate"
    region = var.region
  }
}
