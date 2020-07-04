terraform {
  required_version = ">= 0.12.28"
  backend "s3" {
    key = "state/main/shared_ecr-images_nginx-plus/terraform.tfstate"
  }
}
