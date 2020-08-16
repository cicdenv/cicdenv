data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_backend/terraform.tfstate"
    region = var.region
  }
}
