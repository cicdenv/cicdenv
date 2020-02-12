terraform {
  required_version = "0.11.14"
  backend "s3" {
    key = "kops-clusters-1-16-a-cluster/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
