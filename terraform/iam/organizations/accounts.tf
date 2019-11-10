resource "aws_organizations_account" "accounts" {
  count = length(var.accounts)
  
  name  = lookup(var.accounts[count.index], "name")
  email = lookup(var.accounts[count.index], "email")
  
  iam_user_access_to_billing = "DENY"

  role_name = "${lookup(var.accounts[count.index], "name")}-admin"
  
  provider = "aws.us-east-1"
}
