terraform {
  required_version = ">= 0.12.21"
  backend "s3" {
    key = "kops-clusters-1-18a-cluster-config/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
