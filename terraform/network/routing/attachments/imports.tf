data "terraform_remote_state" "network_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/network_backend/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "network_shared" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/${terraform.workspace}/network_shared/terraform.tfstate"
    region = var.region
  }
}
