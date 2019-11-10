output "console_url" {
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console/"
}

output "switch_role_url" {
  value = "https://signin.aws.amazon.com/switchrole?roleName=${aws_iam_role.assumed_admin.name}&account=${data.aws_caller_identity.current.account_id}"
}
