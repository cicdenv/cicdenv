provider "aws" {
  region = var.target_region
  
  profile = "admin-${terraform.workspace}"
}
