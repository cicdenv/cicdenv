locals {
  region = data.aws_region.current.name

  # kops-driver:
  cluster_name = var.cluster_name

  # kops/backend
  state_store = data.terraform_remote_state.backend.outputs.state_store

  # kops/shared
  iam = data.terraform_remote_state.shared.outputs.iam

  # iam/users
  admin_users = data.terraform_remote_state.iam_users.outputs.admins
  main_admin = data.terraform_remote_state.iam_users.outputs.main_admin_role.arn
  
  # backend (accounts)
  account_admin = data.terraform_remote_state.accounts.outputs.organization_accounts[terraform.workspace].role
  admin_roles  = terraform.workspace == "main" ? [main_admin] : [account_admin]
}
