terraform {
  required_version = ">= 0.12.15"
  backend "s3" {
    key = "state/main/shared-ecr-images-bastion-sshd-worker/terraform.tfstate"
  }
}
