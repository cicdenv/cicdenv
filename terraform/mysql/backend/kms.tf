resource "aws_kms_key" "mysql_secrets" {
  description = "Used for mysql secrets manager secrets"
  policy = data.aws_iam_policy_document.mysql_kms.json
}

resource "aws_kms_alias" "mysql_secrets" {
  name          = "alias/mysql-secrets"
  target_key_id = aws_kms_key.mysql_secrets.key_id
}
