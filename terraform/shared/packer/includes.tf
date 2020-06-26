data "aws_caller_identity" "current" {}

data "aws_ami" "custom_base" {
  most_recent = true

  filter {
    name   = "name"
    values = ["base/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = [local.ami_owner]
}
