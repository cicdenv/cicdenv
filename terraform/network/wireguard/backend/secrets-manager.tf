resource "aws_secretsmanager_secret" "wireguard_keys" {
  name = "wireguard-keys"

  description = "Wireguard keys"
}

resource "aws_secretsmanager_secret_rotation" "wireguard_keys" {
  secret_id           = aws_secretsmanager_secret.wireguard_keys.id
  rotation_lambda_arn = aws_lambda_function.wireguard_keys.arn

  rotation_rules {
    automatically_after_days = 90
  }

  # Ensures lambda before perms are set
  depends_on = [
    aws_iam_role_policy_attachment.wireguard_keys,
  ]
}
