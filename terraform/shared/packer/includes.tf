data "aws_caller_identity" "current" {}

data "aws_ami" "custom_base" {
  for_each = toset(["ext4", "zfs"])

  most_recent = true

  filter {
    name   = "name"
    values = ["base/ubuntu-20.04-amd64-${each.key}-*"]
  }

  owners = [local.ami_owner]
}
