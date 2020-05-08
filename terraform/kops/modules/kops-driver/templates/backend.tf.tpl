terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    key = "kops-clusters-${cluster_instance}-cluster/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
