terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    key = "state/main/shared_ecr-images_bastion-events-worker/terraform.tfstate"
  }
}
