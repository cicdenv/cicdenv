locals {
  # kops/backend
  state_store = data.terraform_remote_state.backend.outputs.state_store

  # kops/shared
  iam = data.terraform_remote_state.shared.outputs.iam

  # iam/users
  admin_users = data.terraform_remote_state.iam_users.outputs.admins
  
  region = data.aws_region.current.name
  
  # kops-driver:
  cluster_fqdn = var.cluster_fqdn
  admin_roles  = var.admin_roles

  authenticator_config = var.output_files.authenticator_config
}
