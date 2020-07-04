resource "aws_kms_key" "nginx_secrets" {
  description = "Used for nginx secrets manager secrets"
  policy = data.aws_iam_policy_document.nginx_kms.json
}

resource "aws_kms_alias" "nginx_secrets" {
  name          = "alias/nginx-secrets"
  target_key_id = aws_kms_key.nginx_secrets.key_id
}
