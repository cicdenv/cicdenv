module "kops_addons" {
  source = "../kops-addons"

  cluster_id  = local.cluster_name
  
  state_store   = local.state_store
  state_key_arn = local.state_key_arn

  admin_users = local.admin_users
  admin_roles = [local.admin_role]

  authenticator_config = local.authenticator_config
}
