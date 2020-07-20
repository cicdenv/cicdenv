resource "aws_secretsmanager_secret" "this" {
  name = "mysql-${var.name}-${var.suffix}-${var.random}"

  description = "MySQL ${var.name} ${upper(var.suffix)} ${var.desc}"
}

resource "aws_secretsmanager_secret_rotation" "this" {
  secret_id           = aws_secretsmanager_secret.this.id
  rotation_lambda_arn = aws_lambda_function.rotator.arn

  rotation_rules {
    automatically_after_days = 90
  }
}
