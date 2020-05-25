data "terraform_remote_state" "backend" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}
