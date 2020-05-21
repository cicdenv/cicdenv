# name
# id
# admin-role
# acct-root
# ou

output "org_account_admin_roles" {
  value = [for acct in keys(var.accounts) : "arn:aws:iam::${aws_organizations_account.accounts[acct].id}:role/${acct}-admin"]
}

output "org_account_roots" {
  value = [for acct in keys(var.accounts) : "arn:aws:iam::${aws_organizations_account.accounts[acct].id}:root"]
}

output "all_account_roots" {
  value = flatten([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root", 
    [for acct in keys(var.accounts) : "arn:aws:iam::${aws_organizations_account.accounts[acct].id}:root"],
  ])
}

output "main_account_root" {
  value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}

output "org_account_ids" {
  value = [for acct in keys(var.accounts) : aws_organizations_account.accounts[acct].id]
}

output "master_account" {
  value = {
    id = data.aws_caller_identity.current.account_id
    alias = data.aws_iam_account_alias.current.account_alias
  }
}

output "account_names" {
  value = keys(var.accounts)
}

output "account_ids_by_name" {
  value = {for name, acct in var.accounts : name => aws_organizations_account.accounts[name].id}
}

output "account_ous_by_name" {
  value = {for name, acct in var.accounts : name => acct.ou}
}

output "organization" {
  value = {
    id = aws_organizations_organization.organization.id
  }
}
