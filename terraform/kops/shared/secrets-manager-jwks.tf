resource "aws_secretsmanager_secret" "oidc_jwks" {
  name = "irsa-service-accounts"

  description = "IRSA - IAM Roles for Kubernetes Service Accounts keys"
}

resource "aws_secretsmanager_secret_rotation" "oidc_jwks" {
  secret_id           = aws_secretsmanager_secret.oidc_jwks.id
  rotation_lambda_arn = aws_lambda_function.oidc_jwks.arn

  rotation_rules {
    automatically_after_days = 90
  }
  
  # Ensures lambda before perms are set
  depends_on = [
    aws_iam_role_policy_attachment.oidc_jwks,
  ]
}
