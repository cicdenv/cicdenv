data "aws_region" "current" {}
data "aws_availability_zones" "azs" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "custom_base" {
  most_recent = true

  filter {
    name   = "name"
    values = ["base/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  owners = ["${local.ami_owner}"]
}
