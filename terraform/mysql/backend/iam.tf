data "aws_iam_policy_document" "mysql_kms" {
  statement {
    principals {
      type = "AWS"

      identifiers = local.all_account_roots
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "mysql_secrets" {
  statement {
    principals {
      type = "AWS"
      identifiers = local.org_account_roots
    }

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "*",
    ]
  }
}
