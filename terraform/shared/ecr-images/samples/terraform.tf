terraform {
  required_version = ">= 0.12.26"
  backend "s3" {
    key = "state/main/shared_ecr-images_samples/terraform.tfstate"
  }
}
