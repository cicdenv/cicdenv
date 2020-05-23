locals {
  main_account = data.terraform_remote_state.accounts.outputs.main_account

  account = {
    id = data.aws_caller_identity.current.account_id
  }
}
