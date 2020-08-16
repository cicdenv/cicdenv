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
  
  # Ensures lambda before perms are set
  depends_on = [
    aws_iam_role_policy_attachment.kops_ca,
  ]
}
