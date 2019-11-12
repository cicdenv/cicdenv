provider "aws" {
  alias   = "ap-northeast-1"
  region  = "ap-northeast-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "ap-northeast-2"
  region  = "ap-northeast-2"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "ap-south-1"
  region  = "ap-south-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "ap-southeast-1"
  region  = "ap-southeast-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "ap-southeast-2"
  region  = "ap-southeast-2"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "ca-central-1"
  region  = "ca-central-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "eu-central-1"
  region  = "eu-central-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "eu-north-1"
  region  = "eu-north-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "eu-west-1"
  region  = "eu-west-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "eu-west-2"
  region  = "eu-west-2"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "eu-west-3"
  region  = "eu-west-3"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "sa-east-1"
  region  = "sa-east-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "us-east-2"
  region  = "us-east-2"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "us-west-1"
  region  = "us-west-1"
  profile = "admin-${terraform.workspace}"
}

provider "aws" {
  alias   = "us-west-2"
  region  = "us-west-2"
  profile = "admin-${terraform.workspace}"
}
