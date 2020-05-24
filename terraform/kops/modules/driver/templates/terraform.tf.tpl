terraform {
  required_version = ">= 0.12.25"
  backend "s3" {
    key = "kops_clusters_${cluster_name}_cluster_${workspace}/terraform.tfstate"

    workspace_key_prefix = "state"
  }
}
