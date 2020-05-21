terraform {
  required_version = ">= 0.12.20"
  backend "s3" {
    key = "kops_nat-gateways/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
