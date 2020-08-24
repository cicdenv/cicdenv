resource "aws_secretsmanager_secret" "gpg" {
  name = "apt-repo-gpg"

  description = "S3 apt repository indexer gpg secrets"
}

resource "aws_secretsmanager_secret_rotation" "gpg" {
  secret_id           = aws_secretsmanager_secret.gpg.id
  rotation_lambda_arn = aws_lambda_function.gpg.arn

  rotation_rules {
    automatically_after_days = 90
  }
  
  # Ensures lambda before perms are set
  depends_on = [
    aws_iam_role_policy_attachment.gpg,
  ]
}
