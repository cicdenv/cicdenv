locals {
  all_account_roots = data.terraform_remote_state.accounts.outputs.all_roots
}
