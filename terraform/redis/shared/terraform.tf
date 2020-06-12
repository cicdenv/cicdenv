terraform {
  required_version = ">= 0.12.26"
  backend "s3" {
    key = "redis_shared/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
