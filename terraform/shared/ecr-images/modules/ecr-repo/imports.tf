data "terraform_remote_state" "accounts" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}
