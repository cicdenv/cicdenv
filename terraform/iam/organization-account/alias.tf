resource "aws_iam_account_alias" "alias" {
  account_alias = "${local.main_account_alias}-${terraform.workspace}"
}
