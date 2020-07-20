resource "aws_secretsmanager_secret" "mysql" {
  name = "mysql"

  description = "MySQL main acct secrets"

  policy = data.aws_iam_policy_document.mysql_secrets.json

  kms_key_id = aws_kms_key.mysql_secrets.id
}
