data "terraform_remote_state" "domains" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/domains/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "network_shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "nginx_shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/nginx_shared/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "nginx_shared_tls" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/${terraform.workspace}/nginx_shared_tls/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "ecr_nginx" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/shared_ecr-images_nginx-plus/terraform.tfstate"
    region = var.terraform_state.region
  }
}

data "terraform_remote_state" "accounts" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}
