resource "aws_iam_account_password_policy" "custom" {
  minimum_password_length        = 12
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = true
  require_symbols                = true

  max_password_age               = 90
  password_reuse_prevention      = 10

  allow_users_to_change_password = true
}
