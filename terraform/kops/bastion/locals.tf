locals {
  vpc_id          = data.terraform_remote_state.shared.outputs.vpc_id
  public_subnets  = data.terraform_remote_state.shared.outputs.public_subnet_ids
  private_subnets = data.terraform_remote_state.shared.outputs.private_subnet_ids

  zone_id = data.terraform_remote_state.domains.outputs.kops_public_zone_id

  security_groups = [
    data.terraform_remote_state.shared.outputs.nodes_security_group_id,
    data.terraform_remote_state.shared.outputs.masters_security_group_id,
  ]

  assume_role_arn = data.terraform_remote_state.iam_assumed_roles.outputs.identity_resolver_role_arn

  ami_owner = data.terraform_remote_state.iam_organizations.outputs.master_account["id"]
  ami       = data.aws_ami.custom_base.id
}
