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

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "account_alias" {
  value = data.aws_iam_account_alias.current.account_alias
}

output "console_url" {
  value = [
    "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console/", 
    "https://${data.aws_iam_account_alias.current.account_alias}.signin.aws.amazon.com/console/",
  ]
}

output "terraform_role_arn" {
  value = aws_iam_role.terraform_admin.arn
}

output "admin_users" {
  value = zipmap(aws_iam_user.admin.*.name, aws_iam_user.admin.*.arn)
}
