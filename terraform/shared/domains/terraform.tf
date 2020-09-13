terraform {
  required_version = ">= 0.13.2"
  backend "s3" {
    key = "state/main/shared_domains/terraform.tfstate"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
