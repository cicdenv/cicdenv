locals {
  allowed_account_roots = data.terraform_remote_state.iam_organizations.outputs.all_account_roots
  allowed_account_ids   = data.terraform_remote_state.iam_organizations.outputs.org_account_ids
}
