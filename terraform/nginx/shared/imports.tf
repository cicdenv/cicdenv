data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/iam_common-policies/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "ecr_nginx" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_ecr-images_nginx-plus/terraform.tfstate"
    region = var.region
  }
}
