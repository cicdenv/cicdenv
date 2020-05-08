terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    key = "kops-clusters-1-18a-cluster/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
