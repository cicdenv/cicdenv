data "terraform_remote_state" "network_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "bastion_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_bastion_backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_common_policies" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_common-policies/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "wireguard-tools_layer" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_layers_wireguard-tools/terraform.tfstate"
    region = var.region
  }
}
