locals {
  main_account_root  = data.terraform_remote_state.iam_organizations.outputs.main_account_root
  main_account_alias = data.terraform_remote_state.iam_organizations.outputs.master_account["alias"]
}
