output "user_passwords" {
  value = zipmap(local.admin_users, aws_iam_user_login_profile.admin.*.encrypted_password)
  description = ""
}

output "user_access_keys" {
  value = zipmap(local.admin_users, aws_iam_access_key.admin.*.id)
  description = ""
}

output "user_secret_keys" {
  value = zipmap(local.admin_users, aws_iam_access_key.admin.*.encrypted_secret)
  description = ""
}

output "admin_users" {
  value = zipmap(aws_iam_user.admin.*.name, aws_iam_user.admin.*.arn)
}

output "main_admin_role" {
  value = {
    name = aws_iam_role.main_admin.name
    arn  = aws_iam_role.main_admin.arn
    path = aws_iam_role.main_admin.path
  }
}
