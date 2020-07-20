output "secret" {
  value = {
    name = aws_secretsmanager_secret.this.name
    arn  = aws_secretsmanager_secret.this.arn
  }
}