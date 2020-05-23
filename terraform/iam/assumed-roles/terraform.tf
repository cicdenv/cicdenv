terraform {
  required_version = ">= 0.12.25"
  backend "s3" {
    key = "state/main/iam_assumed-roles/terraform.tfstate"
  }
}
