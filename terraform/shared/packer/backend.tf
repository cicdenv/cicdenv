terraform {
  required_version = ">= 0.12.24"
  backend "s3" {
    key = "state/main/shared_packer/terraform.tfstate"
  }
}