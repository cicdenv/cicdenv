data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.terraform_state.bucket
    key    = "state/main/lambda_backend/terraform.tfstate"
    region = var.terraform_state.region
  }
}
