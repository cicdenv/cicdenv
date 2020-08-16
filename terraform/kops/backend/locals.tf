locals {
  main_account = data.terraform_remote_state.accounts.outputs.main_account
  organization = data.terraform_remote_state.accounts.outputs.organization
}
