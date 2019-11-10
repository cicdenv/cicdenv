module "default_vpc-ap-northeast-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.ap-northeast-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["ap-northeast-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["ap-northeast-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["ap-northeast-1"]}"
}

module "default_vpc-ap-northeast-2" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.ap-northeast-2"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["ap-northeast-2"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["ap-northeast-2"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["ap-northeast-2"]}"
}

module "default_vpc-ap-south-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.ap-south-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["ap-south-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["ap-south-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["ap-south-1"]}"
}

module "default_vpc-ap-southeast-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.ap-southeast-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["ap-southeast-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["ap-southeast-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["ap-southeast-1"]}"
}

module "default_vpc-ap-southeast-2" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.ap-southeast-2"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["ap-southeast-2"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["ap-southeast-2"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["ap-southeast-2"]}"
}

module "default_vpc-ca-central-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.ca-central-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["ca-central-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["ca-central-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["ca-central-1"]}"
}

module "default_vpc-eu-central-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.eu-central-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["eu-central-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["eu-central-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["eu-central-1"]}"
}

module "default_vpc-eu-north-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.eu-north-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["eu-north-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["eu-north-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["eu-north-1"]}"
}

module "default_vpc-eu-west-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.eu-west-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["eu-west-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["eu-west-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["eu-west-1"]}"
}

module "default_vpc-eu-west-2" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.eu-west-2"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["eu-west-2"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["eu-west-2"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["eu-west-2"]}"
}

module "default_vpc-eu-west-3" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.eu-west-3"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["eu-west-3"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["eu-west-3"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["eu-west-3"]}"
}

module "default_vpc-sa-east-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.sa-east-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["sa-east-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["sa-east-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["sa-east-1"]}"
}

module "default_vpc-us-east-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.us-east-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["us-east-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["us-east-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["us-east-1"]}"
}

module "default_vpc-us-east-2" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.us-east-2"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["us-east-2"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["us-east-2"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["us-east-2"]}"
}

module "default_vpc-us-west-1" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.us-west-1"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["us-west-1"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["us-west-1"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["us-west-1"]}"
}

module "default_vpc-us-west-2" {
  source = "../modules/default-vpc"
  
  providers = {
    aws = "aws.us-west-2"
  }

  default_vpc_cidr         = "${var.default_vpc_cidr["us-west-2"]}"
  default_vpc_subnet_cidrs = "${var.default_vpc_subnet_cidrs["us-west-2"]}"
  default_vpc_subnet_azs   = "${var.default_vpc_subnet_azs["us-west-2"]}"
}
