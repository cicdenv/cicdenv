terraform {
  required_version = ">= 0.13"
  backend "s3" {
    key = "iam_common-policies/terraform.tfstate"

    workspace_key_prefix = "state"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
