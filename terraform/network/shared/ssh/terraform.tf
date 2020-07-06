terraform {
  required_version = ">= 0.12.28"
  backend "s3" {
    key = "network_shared_ssh/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
