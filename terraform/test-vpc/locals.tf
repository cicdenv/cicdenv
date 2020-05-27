locals {
  domain = var.domain

  cidr_blocks = var.whitelisted_cidr_blocks

  availability_zones = [data.aws_availability_zones.azs.names[0]]  # Stick to one AZ 

  assume_role_arns = [
    data.terraform_remote_state.iam_assumed_roles.outputs.iam.identity_resolver.role.arn,
    data.terraform_remote_state.iam_assumed_roles.outputs.iam.ses_sender.role.arn,
  ]

  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy
}
