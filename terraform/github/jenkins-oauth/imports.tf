data "terraform_remote_state" "shared_domains" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/shared_domains/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "lambda" {
  backend = "s3"
  config = {
    bucket = var.bucket
    key    = "state/main/lambda_backend/terraform.tfstate"
    region = var.region
  }
}
