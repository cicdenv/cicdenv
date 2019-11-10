locals {
  all_account_roots = data.terraform_remote_state.iam_organizations.outputs.all_account_roots
}
