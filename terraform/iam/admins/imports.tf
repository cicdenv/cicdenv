data "terraform_remote_state" "iam_common" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/iam-common/terraform.tfstate"
    region = var.region
  }
}
