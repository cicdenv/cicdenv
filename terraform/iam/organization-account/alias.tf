resource "aws_iam_account_alias" "alias" {
  account_alias = "${local.main_account.alias}-${terraform.workspace}"
}
