terraform {
  required_version = ">= 0.12.20"
  backend "s3" {
    key = "kops-clusters-1-16-a-cluster-config/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
