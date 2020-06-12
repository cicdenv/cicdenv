locals {
  ssh_key = "~/.ssh/kops_rsa.pub"
  
  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  vpc_id = data.terraform_remote_state.network.outputs.vpc.id

  bastion_security_group = data.terraform_remote_state.network.outputs.bastion_service.security_group
}
