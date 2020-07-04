resource "aws_secretsmanager_secret" "nginx" {
  name = "nginx"

  description = "NGINX main acct secrets"

  policy = data.aws_iam_policy_document.nginx_secrets.json

  kms_key_id = aws_kms_key.nginx_secrets.id
}
