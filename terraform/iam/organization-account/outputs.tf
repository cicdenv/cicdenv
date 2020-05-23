output "console_url" {
  value = "https://${local.account.id}.signin.aws.amazon.com/console/"
}

output "switch_role_url" {
  value = "https://signin.aws.amazon.com/switchrole?roleName=${aws_iam_role.assumed_admin.name}&account=${local.account.id}"
}
