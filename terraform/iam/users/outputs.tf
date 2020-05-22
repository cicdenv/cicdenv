output "admins" {
  value = {for name, info in var.admins : name => aws_iam_user.admin[name].arn}
}

output "credentials" {
  value = {for name, info in var.admins : name => {
    password   = aws_iam_user_login_profile.admin[name].encrypted_password
    access_key = aws_iam_access_key.admin[name].id
    secret_key = aws_iam_access_key.admin[name].encrypted_secret
  }}
}

output "main_admin_role" {
  value = {
    name = aws_iam_role.main_admin.name
    arn  = aws_iam_role.main_admin.arn
    path = aws_iam_role.main_admin.path
  }
}
