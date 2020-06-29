locals {
  vpc_id           = data.terraform_remote_state.network.outputs.vpc.id
  bastion          = data.terraform_remote_state.network.outputs.bastion_service

  account = terraform.workspace == "main" ? data.terraform_remote_state.accounts.outputs.main_account : data.terraform_remote_state.accounts.outputs.organization_accounts[terraform.workspace]
}
