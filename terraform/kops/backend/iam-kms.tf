data "aws_iam_policy_document" "kops_kms" {
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
