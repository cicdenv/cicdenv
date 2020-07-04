terraform {
  required_version = ">= 0.12.28"
  backend "s3" {
    key = "nginx_shared/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
