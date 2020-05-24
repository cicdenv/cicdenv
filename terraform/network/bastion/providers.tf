provider "aws" {
  region = var.target_region

  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  region = "us-east-1"
  
  alias = "us-east-1"

  profile = "admin-${terraform.workspace}"
}
