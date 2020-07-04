terraform {
  required_version = ">= 0.12.28"
  backend "s3" {
    key = "state/main/nginx_backend/terraform.tfstate"
  }
}
