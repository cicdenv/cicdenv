locals {
  org_account_roots = data.terraform_remote_state.accounts.outputs.org_roots
}
