terraform {
  required_version = ">= 0.12.15"
  backend "s3" {
    key = "kops-clusters-1-16-cluster-config/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
