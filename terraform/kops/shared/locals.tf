locals {
  vpc_id           = data.terraform_remote_state.network.outputs.vpc.id
  bastion          = data.terraform_remote_state.network.outputs.bastion_service
  private_dns_zone = data.terraform_remote_state.network.outputs.private_dns_zone

  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy

  account = terraform.workspace == "main" ? data.terraform_remote_state.accounts.outputs.main_account : data.terraform_remote_state.accounts.outputs.organization_accounts[terraform.workspace]
}
