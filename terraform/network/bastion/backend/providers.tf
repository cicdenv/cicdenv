provider "aws" {
  region = var.region
  
  profile = "admin-main"
}

provider "aws" {
  region = "us-east-1"
  
  alias = "us-east-1"

  profile = "admin-main"
}
