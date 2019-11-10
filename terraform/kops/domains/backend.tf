terraform {
  required_version = ">= 0.12.2"
  backend "s3" {
    key = "state/main/kops-domains/terraform.tfstate"
  }
}
