data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.terraform_state.region
  }
}
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/kops_clusters_${local.cluster_name}_cluster_${terraform.workspace}/terraform.tfstate"
    region = var.terraform_state.region
  }
}
