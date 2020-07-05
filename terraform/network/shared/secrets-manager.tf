resource "aws_secretsmanager_secret" "ssh_keys" {
  name = "shared-ec2-keypair"

  description = "Shared ec2 ssh-key"
}

resource "aws_secretsmanager_secret_rotation" "ssh_keys" {
  secret_id           = aws_secretsmanager_secret.ssh_keys.id
  rotation_lambda_arn = aws_lambda_function.ssh_keys.arn

  rotation_rules {
    automatically_after_days = 90
  }
}
