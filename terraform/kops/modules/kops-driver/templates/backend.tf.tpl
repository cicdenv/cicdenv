terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    key = "kops_clusters_${cluster_instance}_cluster/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
