locals {
  ami_owner = data.aws_caller_identity.current.account_id
  base_ami  = data.aws_ami.custom_base
}
