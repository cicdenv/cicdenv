locals {
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  vpc = data.terraform_remote_state.network_shared.outputs.vpc

  bastion_security_group = data.terraform_remote_state.bastion_backend.outputs.bastion_service.security_group
}
