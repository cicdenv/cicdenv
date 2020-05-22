data "terraform_remote_state" "accounts" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/backend/terraform.tfstate"
    region = var.region
  }
}
