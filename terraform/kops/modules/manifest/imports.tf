data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = var.terraform_settings.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.terraform_settings.region
  }
}

data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.terraform_settings.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.terraform_settings.region
  }
}

data "terraform_remote_state" "shared" {
  backend = "s3"
  config = {
    bucket = var.terraform_settings.bucket
    key    = "state/${terraform.workspace}/kops_shared/terraform.tfstate"
    region = var.terraform_settings.region
  }
}
