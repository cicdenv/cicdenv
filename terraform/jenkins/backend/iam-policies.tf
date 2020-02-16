data "aws_iam_policy_document" "jenkins_key" {
  statement {
    effect = "Allow"

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

data "aws_iam_policy_document" "jenkins_secret" {
  statement {
    effect = "Allow"

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
