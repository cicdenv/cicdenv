terraform {
  required_version = ">= 0.12.2"
  backend "s3" {
    key = "networking-default-vpcs/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
