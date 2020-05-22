resource "aws_organizations_account" "accounts" {
  for_each = var.accounts
  
  name  = each.key
  email = each.value["email"]
  
  iam_user_access_to_billing = "DENY"

  role_name = "${each.key}-admin"
  
  provider = aws.us-east-1
}
