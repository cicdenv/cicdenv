provider "aws" {
  region = var.region
  
  profile = "admin-${terraform.workspace}"
}
