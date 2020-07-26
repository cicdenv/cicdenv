data "aws_caller_identity" "current" {}

data "aws_ami" "custom_base" {
  for_each = toset(
    [for fs in setproduct(
        ["ext4", "zfs",],         # root filesystem
        ["none", "ext4", "zfs",]  # instance store auto configured filesystem
      ) : 
      "${fs[0]}-${fs[1]}"
    ]
  )

  most_recent = true

  filter {
    name   = "name"
    values = ["base/ubuntu-20.04-amd64-${each.key}-*"]
  }

  owners = [local.ami_owner]
}
