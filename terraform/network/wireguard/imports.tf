data "terraform_remote_state" "network_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "wireguard_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_wireguard_backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "wireguard_routing" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_wireguard_routing/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "amis" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_packer/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam_assumed_roles" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam_assumed-roles/terraform.tfstate"
    region = var.region
  }
}
