terraform {
  required_version = ">= 0.12.20"
  backend "s3" {
    key = "state/main/shared_ecr-images_jenkins/terraform.tfstate"
  }
}
