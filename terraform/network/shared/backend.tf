terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    key = "network_shared/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
