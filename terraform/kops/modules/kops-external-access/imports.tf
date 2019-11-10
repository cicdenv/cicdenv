data "aws_region" "current" {}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops-shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "cluster_config" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops-clusters-${local.cluster_short_name}-cluster-config/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/kops-clusters-${local.cluster_short_name}-cluster/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops-domains/terraform.tfstate"
    region = var.region
  }
}
