locals {
  all_account_roots = data.terraform_remote_state.iam_organizations.outputs.all_account_roots

  multi_account_access_policy = data.aws_iam_policy_document.multi_account_access
}
