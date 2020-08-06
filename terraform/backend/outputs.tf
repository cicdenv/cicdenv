output "organization" {
  value = {
    id  = aws_organizations_organization.organization.id
    arn = aws_organizations_organization.organization.arn
  }
}

output "main_account" {
  value = local.main_account
}

output "organization_accounts" {
  value = local.organization_accounts
}

output "all_roots" {
  value = local.all_account_roots
}

output "org_roots" {
  value = local.org_account_roots
}

output "console_urls" {
  value = [
    "https://${local.main_account.id}.signin.aws.amazon.com/console/", 
    "https://${local.main_account.alias}.signin.aws.amazon.com/console/",
  ]
}
