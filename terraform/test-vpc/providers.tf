provider "aws" {
  region = var.region
  
  alias = "main"
  profile = "admin-main"
}

provider "aws" {
  region = var.target_region
  
  profile = "admin-${terraform.workspace}"
}
