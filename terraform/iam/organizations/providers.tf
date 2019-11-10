provider "aws" {
  region = "us-east-1"  # AWS Organizations API is only available in this region

  alias = "us-east-1"
}

provider "aws" {
  region = var.target_region
}
