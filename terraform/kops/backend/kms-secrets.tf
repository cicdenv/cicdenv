resource "aws_kms_key" "kops_secrets" {
  description = "Used for kops secrets manager secrets"
  policy = data.aws_iam_policy_document.kops_kms.json
}

resource "aws_kms_alias" "kops_secrets" {
  name          = "alias/kops-secrets"
  target_key_id = aws_kms_key.kops_secrets.key_id
}
