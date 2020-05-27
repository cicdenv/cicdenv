locals {
  allowed_account_roots = data.terraform_remote_state.accounts.outputs.all_roots
  allowed_account_ids   = values(data.terraform_remote_state.accounts.outputs.organization_accounts)[*]["id"]

  apt_repo_policy = data.terraform_remote_state.iam_common_policies.outputs.iam.apt_repo.policy
}
