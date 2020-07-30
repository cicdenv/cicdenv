terraform {
  required_version = ">= 0.12.29"
  backend "s3" {
    key = "state/main/lambda_layers_cfssl/terraform.tfstate"
  }
}
