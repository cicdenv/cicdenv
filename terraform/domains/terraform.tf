terraform {
  required_version = ">= 0.13.2"
  backend "s3" {
    key = "domains/terraform.tfstate"

    workspace_key_prefix = "state"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
