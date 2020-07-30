data "aws_iam_policy_document" "mysql_kms" {
  statement {
    principals {
      type = "AWS"

      identifiers = [
        local.main_account.root,
      ]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    principals {
      type = "AWS"

      identifiers = [
        "*",
      ]
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:Generate*",
      "kms:Describe*",
      "kms:Get*",
      "kms:List*",
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

data "aws_iam_policy_document" "mysql_secrets" {
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
