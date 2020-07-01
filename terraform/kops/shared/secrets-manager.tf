resource "aws_secretsmanager_secret" "kops_ca" {
  name = "kops-CA"

  description = "KOPS Certificate Authority"
}

resource "aws_secretsmanager_secret_rotation" "kops_ca" {
  secret_id           = aws_secretsmanager_secret.kops_ca.id
  rotation_lambda_arn = aws_lambda_function.kops_ca.arn

  rotation_rules {
    automatically_after_days = 90
  }
}
