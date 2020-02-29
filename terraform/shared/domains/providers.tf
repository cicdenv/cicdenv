provider "aws" {
  region = "us-east-1"

  alias = "special"

  profile = "admin-main"
}

provider "aws" {
  region = var.region
  
  profile = "admin-main"
}
