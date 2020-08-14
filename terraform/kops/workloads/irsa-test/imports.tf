data "terraform_remote_state" "kops_backend" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/kops_backend/terraform.tfstate"
    region = var.region
  }
}
