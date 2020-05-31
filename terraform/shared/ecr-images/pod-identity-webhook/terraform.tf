terraform {
  required_version = ">= 0.12.25"
  backend "s3" {
    key = "state/main/shared_ecr-images_pod-identity-webhook/terraform.tfstate"
  }
}
