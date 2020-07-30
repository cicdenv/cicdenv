resource "aws_secretsmanager_secret" "kops_service_accounts" {
  name = "kops-service-accounts"

  description = "IRSA - IAM Roles for Kubernetes Service Accounts keys"

  policy = data.aws_iam_policy_document.kops_service_accounts.json

  kms_key_id = aws_kms_key.kops_secrets.id
}

data "aws_iam_policy_document" "kops_service_accounts" {
  statement {
    principals {
      type = "AWS"
      
      identifiers = [
        "*",
      ]
    }

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [
        local.organization.id,
      ]
    }
  }
}
