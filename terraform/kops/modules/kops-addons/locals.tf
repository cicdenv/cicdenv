locals {
  admin_arns      = values(var.admin_users)
  admin_usernames = keys(var.admin_users)
}
