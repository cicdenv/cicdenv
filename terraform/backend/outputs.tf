output "vpc_endpoints_dynamodb_table" {
  value = {
    name     = aws_dynamodb_table.vpc_endpoints.name
    hash_key = aws_dynamodb_table.vpc_endpoints.hash_key
  }
}

output "organization" {
  value = {
    id = aws_organizations_organization.organization.id
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
