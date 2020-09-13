terraform {
  required_version = ">= 0.13.2"
  backend "s3" {
    key = "nginx_shared_tls/terraform.tfstate"

    workspace_key_prefix = "state"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    acme = {
      source = "terraform-providers/acme"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}
