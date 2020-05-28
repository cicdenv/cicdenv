data "aws_iam_policy_document" "kops_state_key" {
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

resource "aws_kms_key" "kops_state" {
  description = "Used for kops state store s3 objects"
  policy = data.aws_iam_policy_document.kops_state_key.json
}

resource "aws_kms_alias" "kops_state" {
  name          = "alias/kops-state"
  target_key_id = aws_kms_key.kops_state.key_id
}
