resource "aws_secretsmanager_secret" "nginx_tls" {
  name = "nginx-tls"

  description = "NGINX TLS key"
}

resource "aws_secretsmanager_secret_rotation" "nginx_tls" {
  secret_id           = aws_secretsmanager_secret.nginx_tls.id
  rotation_lambda_arn = aws_lambda_function.nginx_tls.arn

  rotation_rules {
    automatically_after_days = 90
  }

  # Ensures lambda before perms are set
  depends_on = [
    aws_iam_role_policy_attachment.nginx_tls,
  ]
}
