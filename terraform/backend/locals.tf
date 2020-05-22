locals {
  main_account = {
    id    = data.aws_caller_identity.current.account_id
    root  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
    alias = aws_iam_account_alias.alias.account_alias
  }
  
  organization_accounts = {for name, account in var.accounts : name => {
    id   = aws_organizations_account.accounts[name].id
    ou   = account.ou
    root = "arn:aws:iam::${aws_organizations_account.accounts[name].id}:root"
    role = "arn:aws:iam::${aws_organizations_account.accounts[name].id}:role/${name}-admin"
  }}

  org_account_roots = [for account in keys(var.accounts) : "arn:aws:iam::${aws_organizations_account.accounts[account].id}:root"]
  
  all_account_roots = flatten([
    local.main_account.root, 
    local.org_account_roots,
  ])
}
