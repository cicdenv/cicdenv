terraform {
  required_version = ">= 0.12.2"
  backend "s3" {
    key = "kops_shared/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
