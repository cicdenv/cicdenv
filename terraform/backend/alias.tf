resource "aws_iam_account_alias" "alias" {
  account_alias = split(".", var.domain)[0]
}
