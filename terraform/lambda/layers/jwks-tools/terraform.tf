terraform {
  required_version = ">= 0.13.0"
  backend "s3" {
    key = "state/main/lambda_layers_jwks-tools/terraform.tfstate"
  }
}
