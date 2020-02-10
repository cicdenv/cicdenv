terraform {
  required_version = ">= 0.12.2"
  backend "s3" {
    key = "state/main/jenkins-backend/terraform.tfstate"
  }
}