terraform {
  required_version = ">= 0.12.15"
  backend "s3" {
    key = "iam_common-policies/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
