data "aws_region" "current" {}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "cluster_config" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_clusters_${local.cluster_short_name}_cluster-config/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops_clusters_${local.cluster_short_name}_cluster/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops_domains/terraform.tfstate"
    region = var.region
  }
}
